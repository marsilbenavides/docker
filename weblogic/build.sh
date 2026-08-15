#!/bin/sh

WLS_IMAGE_NAME="oxxo-wls:15.1.1.0.0"
if docker image inspect "$WLS_IMAGE_NAME" >/dev/null 2>&1; then
  docker rmi "$WLS_IMAGE_NAME"
fi

docker build\
  --build-arg WLS15_INSTALLER=fmw_15.1.1.0.0_wls_generic.jar\
  --build-arg RESPONSE_FILE=fmw_15.1.1.0.0_wls_generic.responseFile\
  --build-arg JDK_INSTALLER=jdk-21_linux-x64_bin.tar.gz\
  --build-arg MAVEN_INSTALLER=apache-maven-3.9.16-bin.tar.gz\
  --tag "${WLS_IMAGE_NAME}"\
  .
