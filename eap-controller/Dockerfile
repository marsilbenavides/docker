# --- Stage 1: Installer ---
# This stage handles the extraction, installation, and preparation of the Omada application files.
FROM debian:trixie-slim AS installer

# Build-time arguments for the installers
ARG EAP_INSTALLER
ARG JDK17_INSTALLER

# Set basic environment variables for the build process
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=America/Mexico_City
ENV JAVA_HOME=/opt/jdk-17
ENV JRE_HOME=${JAVA_HOME}

# Uncompress the Omada network application installer
# We extract it to a specific directory and strip the first component of the path
COPY ./bin/${EAP_INSTALLER} /tmp/${EAP_INSTALLER}
RUN mkdir /opt/omada-controller-installer &&\
  tar -xvzf /tmp/${EAP_INSTALLER} \
    --directory /opt/omada-controller-installer \
    --strip-components=1 &&\
  rm -rf /tmp/${EAP_INSTALLER}

# Install MongoDB and its required system dependencies
# This includes both the repo keys and the mongodb-org package
RUN apt-get update &&\
  apt-get -y install\
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

# Modify the provided install.sh script and run it
# We use sed to remove the parameter check and root permission check sections
# because they interfere with the automated installation inside the container.
WORKDIR /opt/omada-controller-installer
RUN paramCheckStart=$(grep -n "# parameter check" ./install.sh | cut -d: -f1) &&\
  linesToCut=$(tail -n +$paramCheckStart ./install.sh | grep -n "# root permission check" | cut -d: -f1) &&\
  paramCheckEnd=$(($paramCheckStart+$linesToCut-2)) &&\
  sed -i "${paramCheckStart},${paramCheckEnd}d" ./install.sh &&\
  ./install.sh -y &&\
  rm -rf /opt/omada-controller-installer

# Create a compressed backup of the initial database state
# This is used to restore the database on first startup.
WORKDIR /opt/tplink/EAPController
RUN tar -czf ./data.tar.gz ./data &&\
  rm -rf ./data/*

# Create a custom, minimal JDK 17 runtime using jlink
# This reduces the image footprint by only including necessary modules.
COPY ./bin/${JDK17_INSTALLER} /tmp/${JDK17_INSTALLER}
RUN mkdir -p /tmp/jdk-17-full &&\
  tar -xvzf /tmp/${JDK17_INSTALLER} \
    --directory /tmp/jdk-17-full \
    --strip-components=1 &&\
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

# --- Stage 2: Main Runtime ---
# This stage produces the final production image.
FROM debian:trixie-slim AS main

# Build-time arguments for user identity
ARG OMADA_UID
ARG OMADA_GID

# Configure the runtime environment
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=America/Mexico_City
ENV JAVA_HOME=/opt/jdk-17
ENV JRE_HOME=${JAVA_HOME}
ENV PATH=${JAVA_HOME}/bin:$PATH
ENV OMADA_USER=omada
ENV OMADA_GROUP=omadagrp
ENV OMADA_UID=1000
ENV OMADA_GID=1000

# Define persistent storage volumes
VOLUME [ "/opt/tplink/EAPController/data" ]
VOLUME [ "/opt/tplink/EAPController/logs" ]

# Copy the prepared artifacts from the installer stage
COPY --from=installer ${JAVA_HOME}              ${JAVA_HOME}
COPY --from=installer /opt/tplink/              /opt/tplink
COPY --from=installer /usr/share/java/          /usr/share/java/
COPY --from=installer /usr/share/maven-repo/    /usr/share/maven-repo/

# Copy MongoDB configuration files
COPY --from=installer /usr/share/keyrings/mongodb-server-8.0.gpg      /usr/share/keyrings/
COPY --from=installer /etc/apt/sources.list.d/mongodb-org-8.0.list    /etc/apt/sources.list.d/mongodb-org-8.0.list

# Install final system binaries and set up the application user
# We also ensure the correct group/user ownership on the application directory.
COPY ./entrypoint.sh /opt/tplink/EAPController/entrypoint.sh
RUN apt-get update &&\
  apt-get -y install\
    curl\
    procps\
    gnupg\
    libwrap0\
    mongodb-org &&\
  apt-get clean &&\
  apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false &&\
  rm -rf /var/lib/apt/lists/* &&\
  addgroup --gid ${OMADA_GID} ${OMADA_GROUP} &&\
  adduser ${OMADA_USER}\
    --disabled-password\
    --uid ${OMADA_UID}\
    --gid ${OMADA_GID}\
    --shell /bin/bash\
    --no-create-home\
    --quiet\
    --gecos "" &&\
  chown $OMADA_USER:$OMADA_GROUP -R /opt/tplink/ &&\
  chmod +x /opt/tplink/EAPController/entrypoint.sh

# Set the final working directory and switch to the non-root user
WORKDIR /opt/tplink/EAPController/
USER omada

# Start the application via the entrypoint script
CMD ["./entrypoint.sh"]

