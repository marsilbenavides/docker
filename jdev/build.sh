#!/bin/bash
docker rmi "oxxo-jdev:122100"
docker build\
  --build-arg GROUP_ID=$(id -g ${USER})\
  --build-arg JDEV_VERSION=12.2.1.0.0\
  --build-arg JDEV_INSTALLER_1=jdev_suite_122100_linux64.bin\
  --build-arg JDEV_INSTALLER_2=jdev_suite_122100_linux64-2.zip\
  --build-arg RESPONSE_FILE=jdev_suite_122100_linux64.response\
  --build-arg JDK_INSTALLER=jdk-8u431-linux-x64.tar.gz\
  --tag "oxxo-jdev:122100"\
  .
