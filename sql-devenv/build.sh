#/bin/bash
docker rmi "sql-devenv:slim"
docker build\
  --tag "sql-devenv:slim"\
  .
