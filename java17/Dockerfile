FROM oraclelinux:9 AS build.jdk17
LABEL OWNER="OXXO"

ARG JDK17_INSTALLER

ENV JDK17_INSTALLER=${JDK17_INSTALLER}
ENV JAVA17_HOME="/opt/jdk-17"

# Copy the java installer to the build image
WORKDIR /tmp
COPY bin/${JDK17_INSTALLER} /tmp
RUN tar -xvzf ${JDK17_INSTALLER} && \
  rm -rf ${JDK17_INSTALLER} && \
  mkdir -p ${JAVA17_HOME} && \
  mv /tmp/$(ls /tmp | grep jdk-17)/* ${JAVA17_HOME}

FROM oraclelinux:9-slim AS main
LABEL OWNER="OXXO"
ENV JAVA17_HOME="/opt/jdk-17"
ENV PATH="$PATH:${JAVA17_HOME}/bin"
COPY --from=build.jdk17 /opt /opt
