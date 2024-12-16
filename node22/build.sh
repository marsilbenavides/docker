#!/bin/bash
docker rmi "node22:slim"
docker build\
  --build-arg NODE22_INSTALLER=node-v22.12.0-linux-x64.tar.xz\
  --tag "node22:slim"\
  .
