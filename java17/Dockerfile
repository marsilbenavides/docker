FROM oraclelinux:8-slim AS build
LABEL OWNER="OXXO"

ARG JDK_INSTALLER

ENV JDK_INSTALLER ${JDK_INSTALLER}
ENV JAVA_HOME "/opt/jdk-17"
ENV PATH "$PATH:${JAVA_HOME}/bin"

COPY bin/${JDK_INSTALLER} /tmp
RUN microdnf install gzip -y

WORKDIR /tmp
RUN tar -xvzf ${JDK_INSTALLER} && \
  rm -rf ${JDK_INSTALLER}

WORKDIR /opt
RUN mkdir -p ${JAVA_HOME} && \
    mv /tmp/$(ls /tmp | grep jdk-17)/* ${JAVA_HOME}

# Create main Image
FROM oraclelinux:8-slim AS main
LABEL OWNER="OXXO"
ENV JAVA_HOME "/opt/jdk-17"
ENV PATH "$PATH:${JAVA_HOME}/bin"
COPY --from=build /opt /opt
