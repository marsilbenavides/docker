docker rmi "tomcat-10"
docker build --no-cache^
  --build-arg JDK_INSTALLER=jdk-17_linux-x64_bin.tar.gz^
  --build-arg TOMCAT_INSTALLER=apache-tomcat-10.1.11.tar.gz^
  --tag "tomcat-10"^
  .