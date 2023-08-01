docker rmi "oxxo-node-10:SNAPSHOT"
docker build --no-cache^
  --build-arg NODE_INSTALLER=node-v10.16.1-linux-x64.tar.xz^
  --tag "oxxo-node-10:SNAPSHOT"^
  .