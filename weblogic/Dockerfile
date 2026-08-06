FROM oraclelinux:9 AS build
LABEL OWNER="OXXO"

ARG WLS15_INSTALLER
ARG RESPONSE_FILE
ARG JDK_INSTALLER

ENV JAVA_HOME="/opt/jdk-17-slim"
ENV MW_HOME="/u01/app/oracle/middleware"
ENV WL_HOME="$MW_HOME/wlserver"
ENV WLS_HOME="$MW_HOME/wlserver"
ENV PATH="$PATH:${JAVA_HOME}/bin"

WORKDIR /tmp
COPY /bin/${WLS15_INSTALLER} ./${WLS15_INSTALLER}
COPY /bin/${RESPONSE_FILE}   ./${RESPONSE_FILE}
COPY /bin/${JDK_INSTALLER}   ./${JDK_INSTALLER}

# Extract the JDK installer, use jlink to create a custom runtime image 
# (JRE) in the JAVA_HOME directory, and remove the installer file to save space.
RUN tar -xvzf ${JDK_INSTALLER} &&\
  $(ls -d /tmp/*/ | grep jdk-17)/bin/jlink\
     --module-path $(ls -d /tmp/*/ | grep jdk-17)/jmods\
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

# Run the installer
USER oracle
RUN java -jar ./${WLS15_INSTALLER}\
    -silent\
    -responseFile /tmp/${RESPONSE_FILE}\
    -invPtrLoc /etc/oraInst.loc

# Create the createDomain.responseFile
RUN mkdir -p /u01/app/oracle/middleware/wlserver/domains &&\
  tee /u01/app/oracle/middleware/wlserver/domains/createAxDomain.responseFile > /dev/null <<EOF
read template from "/u01/app/oracle/middleware/wlserver/common/templates/wls/wls.jar";
set JavaHome "${JAVA_HOME}";
set ServerStartMode "dev";

find Server "AdminServer" as AdminServer;
set AdminServer.ListenAddress "";
set AdminServer.ListenPort "7001";

find User "weblogic" as weblogic;
set weblogic.password "Comercio01";

write domain to "/u01/app/oracle/middleware/wlserver/domains/axdomain";
close template;
EOF

USER oracle
RUN (\
  . $WL_HOME/server/bin/setWLSEnv.sh &&\
  $MW_HOME/oracle_common/common/bin/config.sh\
    -mode=silent\
    -log=/u01/app/oracle/middleware/wlserver/domains/createAxDomain.log\
    -silent_script=/u01/app/oracle/middleware/wlserver/domains/createAxDomain.responseFile ||\
  exit 0\
)

# Build the main image
FROM oraclelinux:9-slim AS main
LABEL OWNER="OXXO"
ENV JAVA_HOME="/opt/jdk-17-slim"
ENV MW_HOME="/u01/app/oracle/middleware"
ENV WL_HOME="$MW_HOME/wlserver"
ENV WLS_HOME="$MW_HOME/wlserver"
ENV PATH="$PATH:${JAVA_HOME}/bin"
COPY --from=build /opt /opt
COPY --from=build /u01 /u01

# Create oracle user and groups
RUN useradd -m oracle --shell /bin/sh &&\
  groupadd oinstall &&\
  groupadd dba &&\
  usermod -aG oinstall,dba oracle

WORKDIR $WL_HOME
EXPOSE 7001
CMD ["/u01/app/oracle/middleware/wlserver/domains/axdomain/startWebLogic.sh"]