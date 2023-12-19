#!/bin/bash

# Minecraft Backup Script

# Define variables
SERVER_DIR="/home/azureuser/MC" # Your Minecraft server directory
WORLD_NAME="fartlord-1" # Name of the Minecraft world
BACKUP_DIR="/home/azureuser/MC/backups" # Backup directory
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S") # Timestamp for backup file
BACKUP_FILE="$BACKUP_DIR/${WORLD_NAME}_backup_$TIMESTAMP.tar.gz"

# Ensure backup directory exists
mkdir -p "$BACKUP_DIR"

# Stop the Minecraft server
# Use your method to stop the server. Here's an example using systemd:
sudo systemctl stop minecraft

# Wait a bit to ensure the server has stopped
sleep 10

# Create the backup
tar -czvf "$BACKUP_FILE" -C "$SERVER_DIR" "$WORLD_NAME"

# Restart the Minecraft server
sudo systemctl start minecraft

# Optional: Delete old backups if you want to limit the number of backups
find "$BACKUP_DIR" -name "${WORLD_NAME}_backup_*.tar.gz" -mtime +5 -delete