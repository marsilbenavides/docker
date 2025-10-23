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

# Uncompress java
COPY ./bin/${JDK17_INSTALLER} /tmp/${JDK17_INSTALLER}
RUN mkdir -p ${JAVA_HOME} &&\
  tar -xvzf /tmp/${JDK17_INSTALLER} --directory ${JAVA_HOME} --strip-components=1 &&\
  rm -rf /tmp/${JDK17_INSTALLER}

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
    libwrap0 &&\
  curl -fsSL https://www.mongodb.org/static/pgp/server-8.0.asc | \
      gpg -o /usr/share/keyrings/mongodb-server-8.0.gpg --dearmor &&\
  echo "deb [ signed-by=/usr/share/keyrings/mongodb-server-8.0.gpg ] http://repo.mongodb.org/apt/debian bookworm/mongodb-org/8.0 main" | \
      tee /etc/apt/sources.list.d/mongodb-org-8.0.list &&\
  apt-get update &&\
  apt-get -y install mongodb-org &&\
  addgroup --gid 1000 omadagrp &&\
  adduser omada --disabled-password --uid 1000 --gid 1000 --shell /bin/bash --no-create-home --quiet --gecos ""

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

FROM debian:bookworm-slim AS main
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=America/Mexico_City
ENV JAVA_HOME=/opt/jdk-17
ENV JRE_HOME=${JAVA_HOME}
ENV PATH=${JAVA_HOME}/bin:$PATH

# Restore tplink
VOLUME [ "/opt/tplink/EAPController/data" ]
VOLUME [ "/opt/tplink/EAPController/logs" ]
COPY --from=installer ${JAVA_HOME}              ${JAVA_HOME}
COPY --from=installer /opt/tplink/              /opt/tplink
COPY --from=installer /usr/share/java/          /usr/share/java/
COPY --from=installer /usr/share/maven-repo/    /usr/share/maven-repo/

# Install binaries
RUN apt-get update &&\
  apt-get -y install\
    curl\
    procps\
    gnupg\
    libwrap0 &&\
  curl -fsSL https://www.mongodb.org/static/pgp/server-8.0.asc | \
      gpg -o /usr/share/keyrings/mongodb-server-8.0.gpg --dearmor &&\
  echo "deb [ signed-by=/usr/share/keyrings/mongodb-server-8.0.gpg ] http://repo.mongodb.org/apt/debian bookworm/mongodb-org/8.0 main" | \
      tee /etc/apt/sources.list.d/mongodb-org-8.0.list &&\
  apt-get update &&\
  apt-get -y install mongodb-org &&\
  addgroup --gid 1000 omadagrp &&\
  adduser omada --disabled-password --uid 1000 --gid 1000 --shell /bin/bash --no-create-home --quiet --gecos ""

EXPOSE 8088
EXPOSE 8043
EXPOSE 8843
EXPOSE 27001
EXPOSE 29810
EXPOSE 29811

WORKDIR /opt/tplink/EAPController/
COPY --chmod=777 ./entrypoint.sh /opt/tplink/EAPController/entrypoint.sh
CMD ["./entrypoint.sh"]
