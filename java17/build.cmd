docker rmi "oxxo-java-17"
docker build --no-cache^
  --build-arg JDK_INSTALLER=jdk-17_linux-x64_bin.tar.gz^
  --tag "oxxo-java-17:SNAPSHOT"^
  .