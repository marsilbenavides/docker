#!/bin/bash
docker run -it --rm \
  --entrypoint=/bin/sh\
  -v ./dist:/home/oracle/projects/dist/\
  "oxxo-jdev:122100"
