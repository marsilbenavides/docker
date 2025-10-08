#!/bin/bash
docker rmi "openshift:slim"
docker build --no-cache\
  --tag "openshift:slim"\
  .
