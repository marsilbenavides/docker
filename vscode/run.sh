#!/bin/bash
docker run -it --rm\
  -p 36201:22\
  "oxxo-vscode:jdk17-slim"
