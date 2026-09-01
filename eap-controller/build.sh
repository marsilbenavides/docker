#!/bin/sh
EAP_CONTROLLER_VERSION="6.2.14.11"

docker stop "eap-controller"
docker rm -f "eap-controller"
docker rmi "eap-controller-img:${EAP_CONTROLLER_VERSION}"
docker build .\
  -f ./Dockerfile\
  --network=host\
  --build-arg EAP_INSTALLER=Omada_SDN_Controller_v${EAP_CONTROLLER_VERSION}_linux_x64.tar.gz\
  --build-arg JDK17_INSTALLER=jdk-17.0.20_linux-x64_bin.tar.gz\
  --build-arg OMADA_UID=$(id -u)\
  --build-arg OMADA_GID=$(id -g)\
  --tag "eap-controller-img:${EAP_CONTROLLER_VERSION}"
