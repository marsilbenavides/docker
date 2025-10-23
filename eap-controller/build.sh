#!/bin/sh
docker stop "eap-controller"
docker rm "eap-controller"
docker rmi "eap-controller-img"
docker build .\
  -f ./Dockerfile\
  --network=host\
  --build-arg EAP_INSTALLER=Omada_SDN_Controller_v5.15.24.19_linux_x64_20250724152611.tar.gz\
  --build-arg JDK17_INSTALLER=jdk-17.0.17_linux-x64_bin.tar.gz\
  --tag "eap-controller-img"
