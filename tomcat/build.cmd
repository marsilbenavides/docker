docker rmi "tomcat-10"
docker build --no-cache^
  --build-arg TOMCAT_INSTALLER=apache-tomcat-10.1.11.tar.gz^
  --tag "tomcat-10:SNAPSHOT"^
  .