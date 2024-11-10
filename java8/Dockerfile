FROM rockylinux:9 AS build
LABEL OWNER="OXXO"

ARG JDK_INSTALLER

ENV JDK_INSTALLER=${JDK_INSTALLER}
ENV JAVA_HOME="/opt/jdk1.8"

# Copy the java installer to the build image
WORKDIR /tmp
COPY bin/${JDK_INSTALLER} /tmp
RUN tar -xvzf ${JDK_INSTALLER} && \
  rm -rf ${JDK_INSTALLER} && \
  mkdir -p ${JAVA_HOME} && \
  mv /tmp/$(ls /tmp | grep jdk1.8)/* ${JAVA_HOME} &&\
  rm -rf ${JAVA_HOME}/src.zip &&\
  rm -rf ${JAVA_HOME}/javafx-src.zip

FROM rockylinux:9-minimal AS main
LABEL OWNER="OXXO"
ENV JAVA_HOME="/opt/jdk1.8"
ENV PATH="$PATH:${JAVA_HOME}/bin"
COPY --from=build /opt /opt
