# Minecraft Server Scripts

This repository hosts scripts for managing and updating a Minecraft server, ensuring smooth operation and easy maintenance.

## Minecraft Server Auto-Updater [update_minecraft_server.py](update_minecraft_server.py)

Automatically updates the Minecraft server. The script checks for new versions on the official [Minecraft Server download page](https://www.minecraft.net/en-us/download/server), downloads new releases, archives old versions, and updates the server.

### Features
- Checks for new Minecraft server versions.
- Archives old versions in `old-jars/`.
- Doesn't restart the server. The [backup](backup_minecraft.sh) cron job will eventually restart and the new version will initialize.

### Usage
Run as a weekly cron job. Example (Every Saturday at 08:00):
```bash
0 8 * * 6 /usr/bin/python3 /home/azureuser/update_minecraft_server.py
```
## Minecraft Server Management [mc.sh](mc.sh)
[mc.sh](mc.sh) is a script for initializing and managing a Minecraft server with optimized settings.

### Features
- Optimized Java settings for performance.
- Checks for Java binary and server JAR existence.
- Manages server in a screen session.

### Usage
Set execute permissions and run:

```bash
chmod +x mc.sh
./mc.sh
```
### Systemd Integration
To auto-start at boot and restart on failure:

Create systemd service:
``````
[Unit]
Description=Minecraft Server Launcher
After=network.target

[Service]
Type=forking
WorkingDirectory=/home/azureuser/MC
ExecStart=/home/azureuser/MC/start_minecraft.sh
User=azureuser
Restart=on-failure

[Install]
WantedBy=multi-user.target
``````

Enable and start the service:

```bash
sudo systemctl enable minecraft.service
sudo systemctl start minecraft.service
```

## Minecraft Server Backup [backup_minecraft.sh](backup_minecraft.sh)
Automates the backup process for the Minecraft server world.

### Features
- Stops and restarts the Minecraft server.
- Compresses and stores world backups.
- Configurable backup retention.
### Usage
Set up as a daily cron job:

```cron
0 5 * * * /home/azureuser/MC/backup_minecraft.sh >/dev/null 2>&1
```
Logs details to `/home/azureuser/MC/logs/minecraft_backup.log`.