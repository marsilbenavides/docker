FROM oraclelinux:9 AS build
LABEL OWNER="OXXO"

ARG MVN_INSTALLER
ARG GIT_INSTALLER

ENV MVN_INSTALLER=${MVN_INSTALLER}
ENV GIT_INSTALLER=${GIT_INSTALLER}
ENV M2_HOME="/opt/apache-maven"

WORKDIR /tmp

# Copy the maven installer to the build image
COPY bin/${MVN_INSTALLER} /tmp
RUN tar -xvzf ${MVN_INSTALLER} && \
  rm -rf ${MVN_INSTALLER} && \
  mkdir -p ${M2_HOME} && \
  mv /tmp/$(ls /tmp | grep apache-maven)/* ${M2_HOME} && \
  rm -rf /tmp/$(ls /tmp | grep apache-maven)

# Install git
RUN dnf install\
  gcc\
  make\
  openssl\
  openssl-devel\
  zlib-devel\
  libcurl-devel\
  libcurl-minimal\
  expat\
  expat-devel\
  gettext-libs\
  gettext\
  --skip-broken -y
COPY bin/${GIT_INSTALLER} /tmp
RUN tar -xvzf ${GIT_INSTALLER} && \
  rm -rf ${GIT_INSTALLER} && \
  cd /tmp/$(ls /tmp | grep git) && \
  make prefix=/usr/local all && \
  make prefix=/usr/local install && \
  rm -rf /tmp/$(ls /tmp | grep git)

FROM oraclelinux:9-slim AS main
LABEL OWNER="OXXO"
ENV M2_HOME="/opt/apache-maven"
ENV JAVA_HOME="/opt/jdk1.8"
ENV JAVA17_HOME="/opt/jdk-17"
ENV NODE_HOME="/opt/node22"

# Copy git executable
COPY --from=build /usr/local/bin/git /usr/local/bin/git
COPY --from=build /usr/local/libexec/git-core /usr/local/libexec/git-core
COPY --from=build /usr/local/share/git-core /usr/local/share/git-core
COPY --from=build /var/lib/selinux/targeted/active/modules/100/git /var/lib/selinux/targeted/active/modules/100/git

# Copy expat library
COPY --from=build /usr/share/licenses/expat /usr/share/licenses/expat
COPY --from=build /usr/share/doc/expat /usr/share/doc/expat
COPY --from=build /usr/lib64/libexpat* /usr/lib64/

# Copy gzip library
COPY --from=build /usr/bin/gzip /usr/bin/gzip
COPY --from=build /usr/share/licenses/gzip /usr/share/licenses/gzip
COPY --from=build /usr/share/doc/gzip /usr/share/doc/gzip

# Copy ldconfig library
COPY --from=build /usr/sbin/ldconfig /usr/sbin/ldconfig
COPY --from=build /var/cache/ldconfig /var/cache/ldconfig
COPY --from=build /usr/bin/ld.so /usr/bin/ld.so
COPY --from=build /etc/ld.so.conf /etc/ld.so.conf
COPY --from=build /etc/ld.so.conf.d /etc/ld.so.conf.d
COPY --from=build /etc/ld.so.cache /etc/ld.so.cache

# Copy maven executable
COPY --from=build ${M2_HOME} ${M2_HOME}
ENV PATH="$PATH:${M2_HOME}/bin"

# Copy jdk17 executable
COPY --from=oxxo-java-17:slim ${JAVA17_HOME} ${JAVA17_HOME}

# Copy jdk8 executable (main java version)
COPY --from=oxxo-java-8:slim ${JAVA_HOME} ${JAVA_HOME}
ENV PATH="$PATH:${JAVA_HOME}/bin"

# Copy node executable
COPY --from=node22:slim ${NODE_HOME} ${NODE_HOME}
ENV PATH="$PATH:${NODE_HOME}/bin"

# Configure user
RUN groupadd -r ngroup && \
  useradd -m -r -g ngroup nucleo && \
  mkdir /home/nucleo/projects && \
  chown nucleo:ngroup /home/nucleo/projects
USER nucleo
WORKDIR /home/nucleo/projects
