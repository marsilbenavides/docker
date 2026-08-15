FROM oraclelinux:9 AS build
LABEL OWNER="OXXO"

ARG WLS15_INSTALLER
ARG RESPONSE_FILE
ARG JDK_INSTALLER

ENV JAVA_HOME="/opt/jdk-21-slim"
ENV ORACLE_HOME="/u01/app/oracle/middleware"
ENV MW_HOME="$ORACLE_HOME"
ENV WL_HOME="$ORACLE_HOME/wlserver"
ENV WLS_HOME="$ORACLE_HOME/wlserver"
ENV PATH="$PATH:${JAVA_HOME}/bin"

WORKDIR /tmp
COPY /bin/${WLS15_INSTALLER} ./${WLS15_INSTALLER}
COPY /bin/${RESPONSE_FILE}   ./${RESPONSE_FILE}
COPY /bin/${JDK_INSTALLER}   ./${JDK_INSTALLER}

# Extract the JDK installer, use jlink to create a custom runtime image 
# (JRE) in the JAVA_HOME directory, and remove the installer file to save space.
RUN tar -xvzf ${JDK_INSTALLER} &&\
  $(ls -d ./*/ | grep jdk-21)/bin/jlink\
     --module-path $(ls -d ./*/ | grep jdk-21)/jmods\
     --verbose\
     --compress 2\
     --output ${JAVA_HOME}\
     --add-modules ALL-MODULE-PATH &&\
  rm -rf ./${JDK_INSTALLER}

# Create oracle user and groups
RUN useradd -m oracle &&\
  groupadd oinstall &&\
  groupadd dba &&\
  usermod -aG oinstall,dba oracle

# Create the /etc/oraInst.loc file
RUN tee /etc/oraInst.loc > /dev/null <<EOF
inventory_loc=/u01/app/oraInventory
inst_group=oinstall
EOF
RUN mkdir -p /u01/app/oraInventory &&\
  chown oracle:oinstall /u01/ -R &&\
  chown oracle:oinstall /etc/oraInst.loc

# Run the weblogic installer
USER oracle
RUN java -jar ./${WLS15_INSTALLER}\
    -silent\
    -ignoreSysPrereqs\
    -responseFile /tmp/${RESPONSE_FILE}\
    -invPtrLoc /etc/oraInst.loc

# Build the main image
FROM oraclelinux:9-slim AS main
LABEL OWNER="OXXO"
ENV JAVA_HOME="/opt/jdk-21-slim"
ENV ORACLE_HOME="/u01/app/oracle/middleware"
ENV MW_HOME="$ORACLE_HOME"
ENV WL_HOME="$ORACLE_HOME/wlserver"
ENV WLS_HOME="$ORACLE_HOME/wlserver"
ENV PATH="$PATH:${JAVA_HOME}/bin"

# Create oracle user and groups
RUN useradd -m oracle --shell /bin/bash &&\
  groupadd oinstall &&\
  groupadd dba &&\
  usermod -aG oinstall,dba oracle

# Copy the JDK and Oracle WebLogic installations from the build stage
COPY --from=build /opt /opt
COPY --from=build /u01 /u01
COPY --from=build /home/oracle /home/oracle

# Set the workspace for the oracle user
USER oracle
VOLUME /home/oracle/workspace
WORKDIR /home/oracle/workspace
