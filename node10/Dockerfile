FROM oraclelinux:8-slim
LABEL OWNER="OXXO"

ARG NODE_INSTALLER

ENV NODE_HOME "/usr/local/lib/nodejs-10-linux"
ENV PATH "$PATH:${NODE_HOME}/bin"

COPY bin/${NODE_INSTALLER} /tmp

WORKDIR /tmp
RUN microdnf install xz -y && \
  tar -xvf ${NODE_INSTALLER} && \
  rm -rf ${NODE_INSTALLER}

RUN mkdir -p ${NODE_HOME} && \
    mv /tmp/$(ls /tmp | grep node-v10)/* ${NODE_HOME}
