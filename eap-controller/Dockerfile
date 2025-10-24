FROM debian:bookworm-slim AS installer
ARG EAP_INSTALLER
ARG JDK17_INSTALLER
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=America/Mexico_City
ENV JAVA_HOME=/opt/jdk-17
ENV JRE_HOME=${JAVA_HOME}

# Uncompress omada controller
COPY ./bin/${EAP_INSTALLER} /tmp/${EAP_INSTALLER}
RUN mkdir /opt/omada-controller-installer &&\
  tar -xvzf /tmp/${EAP_INSTALLER} --directory /opt/omada-controller-installer --strip-components=1 &&\
  rm -rf /tmp/${EAP_INSTALLER}

RUN apt-get update &&\
  apt-get -y install\
    openjdk-17-jre-headless\
    jsvc\
    curl\
    procps\
    gnupg\
    apt-utils\
    caps\
    libcap2-bin\
    whiptail\
    libsasl2-modules-gssapi-mit\
    libnsl2\
    libtirpc-common\
    libtirpc3\
    libwrap0\
    binutils &&\
  curl -fsSL https://www.mongodb.org/static/pgp/server-8.0.asc | \
      gpg -o /usr/share/keyrings/mongodb-server-8.0.gpg --dearmor &&\
  echo "deb [ signed-by=/usr/share/keyrings/mongodb-server-8.0.gpg ] http://repo.mongodb.org/apt/debian bookworm/mongodb-org/8.0 main" | \
      tee /etc/apt/sources.list.d/mongodb-org-8.0.list &&\
  apt-get update &&\
  apt-get -y install mongodb-org

# Repair install.sh and execute it
WORKDIR /opt/omada-controller-installer
RUN paramCheckStart=$(grep -n "# parameter check" ./install.sh | cut -d: -f1) &&\
  linesToCut=$(tail -n +$paramCheckStart ./install.sh | grep -n "# root permission check" | cut -d: -f1) &&\
  paramCheckEnd=$(($paramCheckStart+$linesToCut-2)) &&\
  sed -i "${paramCheckStart},${paramCheckEnd}d" ./install.sh &&\
  ./install.sh -y &&\
  rm -rf /opt/omada-controller-installer

# Backup data
WORKDIR /opt/tplink/EAPController
RUN tar -czf ./data.tar.gz ./data &&\
  rm -rf ./data/*

# Uncompress jdk to be used by main image
COPY ./bin/${JDK17_INSTALLER} /tmp/${JDK17_INSTALLER}
RUN mkdir -p /tmp/jdk-17-full &&\
  tar -xvzf /tmp/${JDK17_INSTALLER} --directory /tmp/jdk-17-full --strip-components=1 &&\
  rm -rf /tmp/${JDK17_INSTALLER} &&\
  /tmp/jdk-17-full/bin/jlink\
     --module-path /tmp/jdk-17-full/jmods\
     --verbose\
     --compress 2\
     --strip-debug \
     --no-man-pages \
     --no-header-files \
     --output ${JAVA_HOME}\
     --add-modules ALL-MODULE-PATH

FROM debian:bookworm-slim AS main
ARG OMADA_UID
ARG OMADA_GID
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=America/Mexico_City
ENV JAVA_HOME=/opt/jdk-17
ENV JRE_HOME=${JAVA_HOME}
ENV PATH=${JAVA_HOME}/bin:$PATH
ENV OMADA_USER=omada
ENV OMADA_GROUP=omadagrp
ENV OMADA_UID=1000
ENV OMADA_GID=1000

# Restore tplink
VOLUME [ "/opt/tplink/EAPController/data" ]
VOLUME [ "/opt/tplink/EAPController/logs" ]
COPY --from=installer ${JAVA_HOME}              ${JAVA_HOME}
COPY --from=installer /opt/tplink/              /opt/tplink
COPY --from=installer /usr/share/java/          /usr/share/java/
COPY --from=installer /usr/share/maven-repo/    /usr/share/maven-repo/

# Copy mongo list
COPY --from=installer /usr/share/keyrings/mongodb-server-8.0.gpg      /usr/share/keyrings/
COPY --from=installer /etc/apt/sources.list.d/mongodb-org-8.0.list    /etc/apt/sources.list.d/mongodb-org-8.0.list

# Install binaries
COPY ./entrypoint.sh /opt/tplink/EAPController/entrypoint.sh
RUN apt-get update
RUN apt-get -y install\
    curl\
    procps\
    gnupg\
    libwrap0\
    mongodb-org &&\
  apt-get clean &&\
  apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false &&\
  rm -rf /var/lib/apt/lists/* &&\
  addgroup --gid ${OMADA_GID} ${OMADA_GROUP} &&\
  adduser ${OMADA_USER} --disabled-password --uid ${OMADA_UID} --gid ${OMADA_GID} --shell /bin/bash --no-create-home --quiet --gecos "" &&\
  chown $OMADA_USER:$OMADA_GROUP -R /opt/tplink/ &&\
  chmod +x /opt/tplink/EAPController/entrypoint.sh

EXPOSE 8088
EXPOSE 8043
EXPOSE 8843
EXPOSE 27001
EXPOSE 29810
EXPOSE 29811
EXPOSE 29812
EXPOSE 29813
EXPOSE 29814
EXPOSE 29815
EXPOSE 29816

WORKDIR /opt/tplink/EAPController/
USER omada
CMD ["./entrypoint.sh"]
