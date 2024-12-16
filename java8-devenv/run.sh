#bin/bash
docker rm Java8.DevEnv-slim
docker run -it\
  --name "Java8.DevEnv-slim"\
  --entrypoint=/bin/sh\
  "oxxo-java-8-devenv:slim"
