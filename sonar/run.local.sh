#!/bin/sh
mkdir -p ~/.sonarqube/sonarqube_data
mkdir -p ~/.sonarqube/sonarqube_extensions
mkdir -p ~/.sonarqube/sonarqube_logs

docker stop sonarqube
docker rm sonarqube
docker run -dit\
  --name sonarqube\
  --restart always\
  --publish 9000:9000\
  --volume ~/.sonarqube/sonarqube_data:/opt/sonarqube/data\
  --volume ~/.sonarqube/sonarqube_extensions:/opt/sonarqube/extensions\
  --volume ~/.sonarqube/sonarqube_logs:/opt/sonarqube/logs\
  sonarqube:community
