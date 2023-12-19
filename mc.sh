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

    # Java arguments for server performance tuning
    local java_args=(
        -Xms6G # Initial heap size
        -Xmx6G # Maximum heap size
        -XX:+UseG1GC # Use the G1 Garbage Collector
        -XX:+ParallelRefProcEnabled # Enable parallel reference processing for G1 GC
        -XX:MaxGCPauseMillis=200 # Target for maximum GC pause time
        -XX:+UnlockExperimentalVMOptions # Unlock experimental options for the JVM
        -XX:+DisableExplicitGC # Disable calls to System.gc()
        -XX:+AlwaysPreTouch # Pre-touch memory pages used by the JVM heap
        -XX:G1NewSizePercent=30 # Percentage of the heap to use as the minimum for the young generation
        -XX:G1MaxNewSizePercent=40 # Maximum percentage of heap to use for the young generation
        -XX:G1HeapRegionSize=8M # Set the size of a G1 region
        -XX:G1ReservePercent=20 # Reserve percentage of heap for accommodating young generation
        -XX:G1HeapWastePercent=5 # Percentage of heap that can be wasted
        -XX:G1MixedGCCountTarget=4 # Number of mixed GCs after an evacuation pause
        -XX:InitiatingHeapOccupancyPercent=15 # Percentage of the heap occupancy to trigger a GC cycle
        -XX:G1MixedGCLiveThresholdPercent=90 # Threshold for mixed GC live objects
        -XX:G1RSetUpdatingPauseTimePercent=5 # Time spent on updating the remembered sets
        -XX:SurvivorRatio=32 # Ratio of eden/survivor space size
        -XX:+PerfDisableSharedMem # Disable use of shared memory
        -XX:MaxTenuringThreshold=1 # Maximum value for tenuring threshold
    )

    # Start the Minecraft server inside a screen session
    /usr/bin/screen -dmS "$screen_session_name" /usr/bin/bash -c "cd $working_dir && exec $java_bin ${java_args[*]} -jar $server_jar --nogui"
}

start_minecraft_server