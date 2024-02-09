docker rmi "oxxo-java-8"
docker build --no-cache^
  --build-arg JDK_INSTALLER=jdk-8u401-linux-x64.tar.gz^
  --tag "oxxo-java-8:SNAPSHOT"^
  .