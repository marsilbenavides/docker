#/bin/bash
docker rmi "sql-devenv:SNAPSHOT"
docker build\
  --tag "sql-devenv:SNAPSHOT"\
  .
