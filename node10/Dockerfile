FROM oraclelinux:8-slim AS build
LABEL OWNER="OXXO"

ARG NODE_INSTALLER

ENV NODE_HOME "/usr/local/lib/nodejs-10-linux"
ENV PATH "$PATH:${NODE_HOME}/bin"

COPY bin/${NODE_INSTALLER} /tmp

WORKDIR /tmp
RUN microdnf install xz -y && \
  tar -xvf ${NODE_INSTALLER} && \
  rm -rf ${NODE_INSTALLER} && \
  mkdir -p ${NODE_HOME} && \
  mv /tmp/$(ls /tmp | grep node-v10)/* ${NODE_HOME}

FROM oraclelinux:8-slim AS main
LABEL OWNER="OXXO"
ENV NODE_HOME "/usr/local/lib/nodejs-10-linux"
ENV PATH "$PATH:${NODE_HOME}/bin"
COPY --from=build ${NODE_HOME} ${NODE_HOME}
