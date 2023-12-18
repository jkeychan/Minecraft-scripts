[Minecraft Server](https://www.minecraft.net/en-us/download/server) auto-update script run from weekly cron. The script uses Python Requests and Beautiful Soup to check the [Minecraft Server](https://www.minecraft.net/en-us/download/server) download page for a new version and if it exists, download it, archive the old server, and create a symbolic link to the new version. This will automatically update your Linux Minecraft server.

Notes:

- The script is the username `azureuser`
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
