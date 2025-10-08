#!/bin/bash
docker rmi "oxxo-vscode:jdk17-slim"
docker build --no-cache\
  --tag "oxxo-vscode:jdk17-slim"\
  .
