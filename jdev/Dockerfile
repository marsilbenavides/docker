FROM oraclelinux:8-slim AS build
LABEL OWNER="OXXO"

ARG GROUP_ID
ARG JDEV_VERSION
ARG JDK_INSTALLER
ARG JDEV_INSTALLER_1
ARG JDEV_INSTALLER_2
ARG RESPONSE_FILE

ENV JDK_INSTALLER=${JDK_INSTALLER}
ENV JAVA_HOME="/opt/jdk1.8"

ENV GROUP_ID=${GROUP_ID}
ENV JDEV_VERSION=${JDEV_VERSION}
ENV JDEV_INSTALLER_1=${JDEV_INSTALLER_1}
ENV JDEV_INSTALLER_2=${JDEV_INSTALLER_2}
ENV RESPONSE_FILE=${RESPONSE_FILE}
ENV ORACLE_BASE="/home/oracle/middleware"
ENV ORACLE_HOME="${ORACLE_BASE}/product/${JDEV_VERSION}/dbhome_1"

# Install java
WORKDIR /tmp
COPY bin/${JDK_INSTALLER} /tmp
RUN microdnf install gzip &&\
  tar -xvzf ${JDK_INSTALLER} && \
  rm -rf ${JDK_INSTALLER} && \
  mkdir -p ${JAVA_HOME} && \
  mv /tmp/$(ls /tmp | grep jdk1.8)/* ${JAVA_HOME}

# Add user 'oracle'
RUN groupadd --gid ${GROUP_ID} oracle &&\
  useradd --gid ${GROUP_ID} -ms /bin/bash oracle

# Configure (as root)
WORKDIR /home/oracle
COPY ./config/createCentralInventory.sh createCentralInventory.sh
RUN chmod +x createCentralInventory.sh &&\
  ./createCentralInventory.sh ${ORACLE_BASE} oracle &&\
  chown oracle:${GROUP_ID} /home/oracle -R

# Change 'oracle' user
USER oracle
WORKDIR /home/oracle

# Copy jdev installer and response file
COPY --chown=oracle:oracle ./bin/${JDEV_INSTALLER_1} ${JDEV_INSTALLER_1}
COPY --chown=oracle:oracle ./bin/${JDEV_INSTALLER_2} ${JDEV_INSTALLER_2}
COPY --chown=oracle:oracle ./config/${RESPONSE_FILE} ${RESPONSE_FILE}

# Install jdev
RUN export PATH=$PATH:${JAVA_HOME}/bin &&\
  chmod +x ${JDEV_INSTALLER_1} &&\
  ./${JDEV_INSTALLER_1} -silent -responseFile /home/oracle/${RESPONSE_FILE}

# Cleanup
RUN rm -rf ./${JDEV_INSTALLER_1} &&\
  rm -rf ./${JDEV_INSTALLER_2} &&\
  rm -rf ./${RESPONSE_FILE}


# Build main image
FROM oraclelinux:8-slim AS main

ARG GROUP_ID
ARG JDEV_VERSION

ENV JAVA_HOME="/opt/jdk1.8"
ENV GROUP_ID=${GROUP_ID}
ENV JDEV_VERSION=${JDEV_VERSION}
ENV ORACLE_BASE="/home/oracle/middleware"
ENV ORACLE_HOME="${ORACLE_BASE}/product/${JDEV_VERSION}/dbhome_1"
ENV JDEV_HOME="${ORACLE_HOME}/jdeveloper/jdev"
ENV PATH="${JAVA_HOME}/bin:${JDEV_HOME}/bin:${PATH}"
RUN microdnf install file &&\
  groupadd --gid ${GROUP_ID} oracle &&\
  useradd --gid ${GROUP_ID} -ms /bin/bash oracle &&\
  mkdir /home/oracle/projects &&\
  mkdir /home/oracle/projects/dist &&\
  chown oracle:${GROUP_ID} /home/oracle -R
COPY --from=build /opt /opt
COPY --from=build /home/oracle /home/oracle
VOLUME /home/oracle/projects/dist/
USER oracle
