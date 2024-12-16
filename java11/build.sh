#!/bin/bash
docker rmi "oxxo-java-11-slim"
docker build --no-cache\
  --build-arg JDK_INSTALLER=jdk-11.0.22_linux-x64_bin.tar.gz\
  --tag "oxxo-java-11-slim:SNAPSHOT"\
  .
