docker rmi "oxxo-eureka-server"
docker build --no-cache^
  --build-arg EUREKA_SERVER_JAR=eureka-server-0.0.1-SNAPSHOT.jar^
  --build-arg JAVA_OPTIONS="-server -Djava.awt.headless=true" ^
  --tag "oxxo-eureka-server:SNAPSHOT"^
  .