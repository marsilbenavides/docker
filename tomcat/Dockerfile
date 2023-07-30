FROM oraclelinux:8-slim AS build
LABEL OWNER="OXXO"

ENV JDK_INSTALLER "jdk-17_linux-x64_bin.tar.gz"
ENV TOMCAT_INSTALLER "apache-tomcat-10.1.11.tar.gz"
ENV JAVA_HOME "/opt/jdk-17.0.8"
ENV CATALINA_HOME "/opt/apache-tomcat-10.1.11"
ENV CATALINA_BASE ${CATALINA_HOME}
ENV PATH "$PATH:/${JAVA_HOME}/bin"
ENV COMMONS_DAEMON_VERSION 1.3.4

COPY bin/${JDK_INSTALLER} /opt
COPY bin/${TOMCAT_INSTALLER} /opt
RUN microdnf update -y && \
    microdnf upgrade -y && \
    microdnf install gzip gcc make -y

WORKDIR /opt
RUN tar -xvzf ${JDK_INSTALLER} && \
    rm -rf ${JDK_INSTALLER}
RUN tar -xvzf ${TOMCAT_INSTALLER} && \
    rm -rf ${TOMCAT_INSTALLER}

WORKDIR $CATALINA_HOME/bin
RUN tar -xvzf commons-daemon-native.tar.gz & \
    rm -rf $CATALINA_HOME/webapps/*

WORKDIR $CATALINA_HOME/bin/commons-daemon-${COMMONS_DAEMON_VERSION}-native-src/unix
RUN ./configure && \
    make && \
    cp jsvc $CATALINA_HOME/bin

# CLEAN
RUN microdnf remove gzip gcc make -y && \
    microdnf clean all


FROM oraclelinux:8-slim AS main
LABEL OWNER="OXXO"
ENV JAVA_HOME "/opt/jdk-17.0.8"
ENV CATALINA_HOME "/opt/apache-tomcat-10.1.11"
ENV CATALINA_BASE ${CATALINA_HOME}
COPY --from=build /opt /opt
EXPOSE 8080
CMD $CATALINA_HOME/bin/daemon.sh run
