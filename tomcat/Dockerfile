FROM oraclelinux:8-slim AS build
LABEL OWNER="OXXO"

ARG JDK_INSTALLER
ARG TOMCAT_INSTALLER

ENV JDK_INSTALLER ${JDK_INSTALLER}
ENV TOMCAT_INSTALLER ${TOMCAT_INSTALLER}
ENV JAVA_HOME "/opt/jdk-17"
ENV CATALINA_HOME "/opt/apache-tomcat-10"
ENV CATALINA_BASE ${CATALINA_HOME}
ENV PATH "$PATH:${JAVA_HOME}/bin"

COPY bin/${JDK_INSTALLER} /tmp
COPY bin/${TOMCAT_INSTALLER} /tmp
RUN microdnf install gzip gcc make -y

WORKDIR /tmp
RUN tar -xvzf ${JDK_INSTALLER} && \
  rm -rf ${JDK_INSTALLER}
RUN tar -xvzf /tmp/${TOMCAT_INSTALLER} && \
  rm -rf ${TOMCAT_INSTALLER}

WORKDIR /opt
RUN mkdir -p ${JAVA_HOME} && \
    mv /tmp/$(ls /tmp | grep jdk-17)/* ${JAVA_HOME}
RUN mkdir -p ${CATALINA_HOME} && \
    mv /tmp/$(ls /tmp | grep apache-tomcat-10)/* ${CATALINA_HOME} && \
    rm -rf ${CATALINA_HOME}/webapps/*

WORKDIR $CATALINA_HOME/bin
RUN tar -xvzf commons-daemon-native.tar.gz

RUN export COMMONS_DAEMON_DIR=$CATALINA_HOME/bin/$(ls $CATALINA_HOME/bin | grep commons-daemon | grep native-src) && \
    cd ${COMMONS_DAEMON_DIR}/unix && \
    ./configure && \
    make && \
    cp jsvc $CATALINA_HOME/bin

# Create main Image
FROM oraclelinux:8-slim AS main
LABEL OWNER="OXXO"
ENV JSVC_OPTS "-jvm server"
ENV JAVA_HOME "/opt/jdk-17"
ENV CATALINA_HOME "/opt/apache-tomcat-10"
ENV CATALINA_BASE ${CATALINA_HOME}
ENV PATH "$PATH:${JAVA_HOME}/bin"
COPY --from=build /opt /opt
EXPOSE 8080
CMD $CATALINA_HOME/bin/daemon.sh run
