FROM oxxo-java-17:SNAPSHOT AS build
LABEL OWNER="OXXO"

ARG TOMCAT_INSTALLER

ENV TOMCAT_INSTALLER ${TOMCAT_INSTALLER}
ENV CATALINA_HOME "/opt/apache-tomcat-10"
ENV CATALINA_BASE ${CATALINA_HOME}

COPY bin/${TOMCAT_INSTALLER} /tmp
RUN microdnf install gzip gcc make -y

WORKDIR /tmp
RUN tar -xvzf /tmp/${TOMCAT_INSTALLER} && \
  rm -rf ${TOMCAT_INSTALLER}

WORKDIR /opt
RUN mkdir -p ${CATALINA_HOME} && \
    mv /tmp/$(ls /tmp | grep apache-tomcat-10)/* ${CATALINA_HOME} && \
    rm -rf ${CATALINA_HOME}/webapps/*

WORKDIR $CATALINA_HOME/bin
RUN tar -xvzf commons-daemon-native.tar.gz && \
    cd $(ls | grep commons-daemon | grep native-src)/unix && \
    ./configure && \
    make && \
    cp jsvc $CATALINA_HOME/bin

# Create main Image
FROM oxxo-java-17:SNAPSHOT AS main
LABEL OWNER="OXXO"
ENV JSVC_OPTS "-jvm server"
ENV CATALINA_HOME "/opt/apache-tomcat-10"
ENV CATALINA_BASE ${CATALINA_HOME}
COPY --from=build /opt /opt
EXPOSE 8080
CMD $CATALINA_HOME/bin/daemon.sh run
