# Minecraft Server Auto-Updater

## `update_minecraft_server.py`
[Minecraft Server](https://www.minecraft.net/en-us/download/server) auto-update script run from weekly cron. The `update_minecraft_server.py` script uses Python Requests and Beautiful Soup to check the [Minecraft Server](https://www.minecraft.net/en-us/download/server) download page for a new version and if it exists, download it, archive the old server, and create a symbolic link to the new version. This will automatically update your Linux Minecraft server.

## Notes:

- The script uses the username `azureuser`
- The server directory is `/home/azureuser/MC`
- Under `/home/azureuser/MC` are `logs/` and `old-jars/` directories
- You will need to manually restart the server after the upgrade if it occurs (`cron` is the simplest way)




```bash
0 8 * * 6 /usr/bin/python3 /home/azueruser/update_minecraft_server.py
```
This cron job breaks down as follows:

At 8:00 AM (0 8) on every day of the month (\*), in every month (\*), on Saturday (6) run this command:

```bash
/usr/bin/python3 /home/azureuser/update_minecraft_server.py
```


# Minecraft Server Management Scripts

This repository contains various scripts for managing a Minecraft server. One of the key scripts is `mc.sh`, which is designed to efficiently start and manage a Minecraft server.

## mc.sh Script

The `mc.sh` script initializes a Minecraft server with optimized Java settings for performance. It ensures that necessary files are present and launches the server in a screen session for easy management.

### Features

- Optimized Java arguments for server performance
- Checks for the existence of the Java binary and server JAR
- Runs the server in a screen session

### Usage

Give the script execute permissions:

```chmod +x mc.sh```


Run the script using:

```bash
./mc.sh
```

## Systemd Integration

The `mc.sh` script can be configured to run as a systemd service, ensuring that the Minecraft server starts automatically on system boot and restarts on failure.

### minecraft.service

Create a systemd service file `/etc/systemd/system/minecraft.service`:

```ini
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
```

Enable and start the service:

```bash
sudo systemctl enable minecraft.service
sudo systemctl start minecraft.service
```

Check the service status:

```bash
sudo systemctl status minecraft.service
```