#!/bin/bash

# Minecraft Backup Script

# Configuration
SERVER_DIR="/home/azureuser/MC"
WORLD_NAME="$YOURWORLDNAME"
BACKUP_DIR="/home/azureuser/MC/backups"
RETENTION_DAYS=8 # Number of days to keep backups
LOG_FILE="/home/azureuser/MC/logs/minecraft_backup.log"

# Create backup filename
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
BACKUP_FILE="$BACKUP_DIR/${WORLD_NAME}_backup_$TIMESTAMP.tar.gz"

# Ensure backup directory exists
mkdir -p "$BACKUP_DIR"

# Logging function
log() {
    echo "[$(date +"%Y-%m-%d %H:%M:%S")] $1" | tee -a "$LOG_FILE"
}

# Stop the Minecraft server
log "Stopping Minecraft server..."
if ! sudo systemctl stop minecraft; then
    log "Error stopping server"
    exit 1
fi

# Wait for server to stop
sleep 10

# Backup
log "Creating backup..."
if tar -czvf "$BACKUP_FILE" -C "$SERVER_DIR" "$WORLD_NAME"; then
    log "Backup created successfully"
else
    log "Error creating backup"
    exit 1
fi

# Start the Minecraft server
log "Starting Minecraft server..."
if ! sudo systemctl start minecraft; then
    log "Error starting server"
    exit 1
fi

# Delete old backups
log "Deleting old backups..."
find "$BACKUP_DIR" -name "${WORLD_NAME}_backup_*.tar.gz" -mtime +$RETENTION_DAYS -delete

log "Backup process completed"