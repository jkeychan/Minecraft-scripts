#!/bin/bash

# Minecraft Server Startup Script

start_minecraft_server() {
    local java_bin="/usr/bin/java"
    local working_dir="/home/azureuser/MC"
    local server_jar="/home/azureuser/MC/server.jar"
    local screen_session_name="MC"

    # Check if Java binary exists
    if [ ! -f "$java_bin" ]; then
        echo "Error: Java binary not found at $java_bin"
        exit 1
    fi

    # Check if server JAR exists
    if [ ! -f "$server_jar" ]; then
        echo "Error: Server JAR not found at $server_jar"
        exit 1
    fi

    # Java arguments
    local java_args=(
        -Xms6G
        -Xmx6G
        -XX:+UseG1GC
        -XX:+ParallelRefProcEnabled
        -XX:MaxGCPauseMillis=200
        -XX:+UnlockExperimentalVMOptions
        -XX:+DisableExplicitGC
        -XX:+AlwaysPreTouch
        -XX:G1NewSizePercent=30
        -XX:G1MaxNewSizePercent=40
        -XX:G1HeapRegionSize=8M
        -XX:G1ReservePercent=20
        -XX:G1HeapWastePercent=5
        -XX:G1MixedGCCountTarget=4
        -XX:InitiatingHeapOccupancyPercent=15
        -XX:G1MixedGCLiveThresholdPercent=90
        -XX:G1RSetUpdatingPauseTimePercent=5
        -XX:SurvivorRatio=32
        -XX:+PerfDisableSharedMem
        -XX:MaxTenuringThreshold=1
    )

    # Start the Minecraft server inside a screen session
    /usr/bin/screen -dmS "$screen_session_name" /usr/bin/bash -c "cd $working_dir && exec $java_bin ${java_args[*]} -jar $server_jar --nogui"
}

start_minecraft_server