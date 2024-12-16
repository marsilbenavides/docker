#bin/bash
docker rmi "msservercore:SNAPSHOT"
docker build\
  --tag "msservercore:SNAPSHOT"\
  .
