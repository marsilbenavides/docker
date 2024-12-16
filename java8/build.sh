#bin/bash
docker rmi "oxxo-java-8:slim"
docker build --no-cache\
  --build-arg JDK8_INSTALLER=jdk-8u431-linux-x64.tar.gz\
  --tag "oxxo-java-8:slim"\
  .
