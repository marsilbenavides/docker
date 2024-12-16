#bin/bash
docker run -it -d\
  --name "Sql.DevEnv"\
  --net host\
  --entrypoint=/bin/sh\
  "sql-devenv:SNAPSHOT"
