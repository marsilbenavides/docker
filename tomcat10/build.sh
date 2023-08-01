#!/bin/bash
docker rmi "oxxo-tomcat-10:SNAPSHOT"
docker build --no-cache \
  --build-arg TOMCAT_INSTALLER=apache-tomcat-10.1.11.tar.gz \
  --tag "oxxo-tomcat-10:SNAPSHOT" \
  .

