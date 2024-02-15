FROM rockylinux:9.3 AS build

ARG WILDFLY_INSTALLER

ENV WILDFLY_INSTALLER ${WILDFLY_INSTALLER}
ENV WILDFLY_HOME "/opt/wildfly-21"

# Copy the wildfly installer to the build image
WORKDIR /tmp
COPY bin/${WILDFLY_INSTALLER} /tmp
RUN tar -xvzf ${WILDFLY_INSTALLER} && \
  rm -rf ${WILDFLY_INSTALLER} && \
  mkdir -p ${WILDFLY_HOME} && \
  mv /tmp/$(ls /tmp | grep wildfly-21)/* ${WILDFLY_HOME} && \
  rm -rf ${WILDFLY_HOME}/modules/system/layers/base/org/eclipse/persistence/main/*

FROM oxxo-java-11-slim:SNAPSHOT AS main
LABEL OWNER="OXXO"
ENV JAVA_HOME "/opt/jdk-11-slim"
ENV WILDFLY_HOME "/opt/wildfly-21"
ENV PATH "$PATH:${JAVA_HOME}/bin"
COPY --from=build /opt /opt
EXPOSE 8080
EXPOSE 9990
EXPOSE 8447
CMD ["/opt/wildfly-21/bin/standalone.sh","-b","0.0.0.0","-bmanagement","0.0.0.0","-Djava.net.preferIPv4Stack=true","-c","standalone.xml"]
