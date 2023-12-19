#!/usr/bin/bash
bin="/usr/bin/java"
cwd="/home/azureuser/MC"
server="/home/azureuser/MC/server.jar"
# Updated log format to include timezone
log_format="-Djava.util.logging.SimpleFormatter.format='[%1$tF-%1$tT%1$tz] [%4$s] %5$s %n'"
args="-Xms6G -Xmx6G -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1 -jar $server --nogui $log_format"

/usr/bin/screen -dmS MC /usr/bin/bash -c "cd $cwd && $bin $args"