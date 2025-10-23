#!/bin/sh
db_backup="$(pwd)/data.tar.gz";
data_db_filename="$(pwd)/data/db";

# If database doesn't exist, create it
if [ ! -e "$data_db_filename" ]; then
  echo "Extracting database backup..."
  tar -xzf "${db_backup}"
  rm -rf "${db_backup}"
  echo "Restore complete."
fi

./bin/control.sh start
sleep infinity
