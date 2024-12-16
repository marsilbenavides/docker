FROM oraclelinux:9 AS build.jdk8
LABEL OWNER="OXXO"

ARG JDK8_INSTALLER

ENV JDK8_INSTALLER=${JDK8_INSTALLER}
ENV JAVA_HOME="/opt/jdk1.8"

# Copy the java installer to the build image
WORKDIR /tmp
COPY bin/${JDK8_INSTALLER} /tmp
RUN tar -xvzf ${JDK8_INSTALLER} && \
  rm -rf ${JDK8_INSTALLER} && \
  mkdir -p ${JAVA_HOME} && \
  mv /tmp/$(ls /tmp | grep jdk1.8)/* ${JAVA_HOME} &&\
  rm -rf ${JAVA_HOME}/src.zip &&\
  rm -rf ${JAVA_HOME}/javafx-src.zip

FROM oraclelinux:9-slim AS main
LABEL OWNER="OXXO"
ENV JAVA_HOME="/opt/jdk1.8"
ENV PATH="$PATH:${JAVA_HOME}/bin"
COPY --from=build.jdk8 /opt /opt
