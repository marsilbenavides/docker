#!/bin/bash
docker rmi "oxxo-java-17:slim"
docker build --no-cache\
  --build-arg JDK17_INSTALLER=jdk-17.0.13_linux-x64_bin.tar.gz\
  --tag "oxxo-java-17:slim"\
  .
