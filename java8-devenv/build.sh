#bin/bash
docker rmi "oxxo-java-8-devenv:slim"
docker build\
  --build-arg MVN_INSTALLER=apache-maven-3.9.9-bin.tar.gz\
  --build-arg GIT_INSTALLER=git-2.47.1.tar.gz\
  --build-arg JDK17_INSTALLER=jdk-17.0.13_linux-x64_bin.tar.gz\
  --tag "oxxo-java-8-devenv:slim"\
  .
