#!/bin/bash
docker rmi "oxxo-jdev:121300"
docker build\
  --build-arg GROUP_ID=$(id -g ${USER})\
  --build-arg JDEV_VERSION=12.1.3.0.0\
  --build-arg JDEV_INSTALLER=jdev_suite_121300_linux64.bin\
  --build-arg RESPONSE_FILE=jdev_suite_121300_linux64.response\
  --build-arg JDK_INSTALLER=jdk-8u431-linux-x64.tar.gz\
  --tag "oxxo-jdev:121300"\
  .
