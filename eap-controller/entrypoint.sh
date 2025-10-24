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

cd /opt/tplink/EAPController/lib/
java -server\
  -Xms1024M\
  -Xmx2048M\
  -XX:MaxHeapFreeRatio=60\
  -XX:MinHeapFreeRatio=30\
  -XX:+HeapDumpOnOutOfMemoryError\
  -XX:HeapDumpPath=/opt/tplink/EAPController/logs/java_heapdump.hprof\
  -Djava.awt.headless=true\
  -Djdk.lang.Process.launchMechanism=vfork\
  -cp /usr/share/java/commons-daemon.jar:/opt/tplink/EAPController/lib/*:/opt/tplink/EAPController/properties\
  com.tplink.smb.omada.starter.OmadaLinuxMain start
