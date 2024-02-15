docker rmi "oxxo-wildfly21-slim:SNAPSHOT"
docker build^
  --build-arg WILDFLY_INSTALLER=wildfly-21.0.2.Final.tar.gz^
  --tag "oxxo-wildfly21-slim:SNAPSHOT"^
  .
