#!/bin/bash
docker rmi "oxxo-java-17:slim"
docker build --no-cache\
  --tag "oxxo-java-17:slim"\
  .
