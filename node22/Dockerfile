FROM oraclelinux:9 AS build.node22
LABEL OWNER="OXXO"

ARG NODE22_INSTALLER

ENV NODE22_INSTALLER=${NODE22_INSTALLER}
ENV NODE_HOME="/opt/node22"

# Copy the java installer to the build image
WORKDIR /tmp
COPY bin/${NODE22_INSTALLER} /tmp
RUN dnf install xz -y && \
  tar -xvf ${NODE22_INSTALLER} && \
  rm -rf ${NODE22_INSTALLER} && \
  mkdir -p ${NODE_HOME} && \
  mv /tmp/$(ls /tmp | grep node-v22)/* ${NODE_HOME}


FROM oraclelinux:9-slim AS main
LABEL OWNER="OXXO"
ENV NODE_HOME="/opt/node22"
ENV PATH="$PATH:${NODE_HOME}/bin"
COPY --from=build.node22 /opt /opt
