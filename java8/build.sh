#!/bin/bash
docker rmi "oxxo-java-8:SNAPSHOT"
docker build --no-cache\
  --build-arg JDK_INSTALLER=jdk-8u431-linux-x64.tar.gz\
  --tag "oxxo-java-8:SNAPSHOT"\
  .

docker run -it --rm \
  "oxxo-java-8:SNAPSHOT" \
  java -version
