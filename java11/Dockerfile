FROM rockylinux:9.3 AS build
LABEL OWNER="OXXO"

ARG JDK_INSTALLER

ENV JDK_INSTALLER ${JDK_INSTALLER}
ENV JAVA_HOME "/opt/jdk-11-slim"
ENV PATH "$PATH:${JAVA_HOME}/bin"

# Copy the installer to the build image and uncompress it and Make it slim
WORKDIR /tmp
COPY bin/${JDK_INSTALLER} /tmp
RUN tar -xvzf ${JDK_INSTALLER} && \
  $(ls -d /tmp/*/ | grep jdk-11)/bin/jlink \
     --module-path $(ls -d /tmp/*/ | grep jdk-11)/jmods \
     --verbose \
     --compress 2 \
     --output ${JAVA_HOME} \
     --add-modules ALL-MODULE-PATH

# Create main Image
FROM rockylinux:9.3-minimal AS main
LABEL OWNER="OXXO"
ENV JAVA_HOME "/opt/jdk-11-slim"
ENV PATH "$PATH:${JAVA_HOME}/bin"
COPY --from=build /opt /opt
