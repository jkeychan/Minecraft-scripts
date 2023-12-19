#!/bin/bash

# Minecraft Server Startup Script

# Define the path to the Java binary
JAVA_BIN="/usr/bin/java"

# Define the working directory for the Minecraft server
WORKING_DIR="/home/azureuser/MC"

# Define the path to the Minecraft server JAR file
SERVER_JAR="/home/azureuser/MC/server.jar"

# Define Java arguments
JAVA_ARGS="-Xms6G -Xmx6G -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1"

# Define the log format (currently not effective for Minecraft logging)
LOG_FORMAT="-Djava.util.logging.SimpleFormatter.format='[%1$tF-%1$tT%1$tz] [%4$s] %5$s %n'"

# Start the Minecraft server inside a screen session
/usr/bin/screen -dmS MC /usr/bin/bash -c "cd $WORKING_DIR && $JAVA_BIN $JAVA_ARGS $LOG_FORMAT -jar $SERVER_JAR --nogui"