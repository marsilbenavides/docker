#!/bin/sh

# Define paths for the database backup and the target database file
db_backup="$(pwd)/data.tar.gz"
data_db_filename="$(pwd)/data/db"

# Initialize the database:
# If the database directory does not exist, extract the bundled database backup.
# This ensures that the application has a valid initial state on first boot.
if [ ! -e "$data_db_filename" ]; then
  echo "Extracting database backup..."
  tar -xzf "${db_backup}"
  rm -rf "${db_backup}"
  echo "Restore complete."
fi

# Move to the library directory where the application binaries reside
cd /opt/tplink/EAPController/lib/

# Launch the Omada application with the following JVM configuration:
# - Xms/Xmx: Set heap size between 1GB and 2GB
# - HeapFreeRatio: Optimize how the JVM manages free memory
# - HeapDump: Ensure memory dumps are captured on OutOfMemory errors for debugging
# - Headless: Run without a graphical user interface
# - vfork: Optimization for process launching in specific environments
# - cp: Define the classpath including common daemon jars, application libraries, and properties
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
