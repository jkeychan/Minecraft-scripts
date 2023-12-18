[Minecraft Server](https://www.minecraft.net/en-us/download/server) auto-update script run from weekly cron. Script uses Python requests and Beautiful Soup to check the [Minecraft Server](https://www.minecraft.net/en-us/download/server) download page for a new version and if it exists, download it, archive the old server, and create a symbolic link to the new version.


```bash
0 8 * * 6 /usr/bin/python3 /home/azueruser/update_minecraft_server.py
```
This cron job breaks down as follows:

At 8:00 AM (0 8) on every day of the month (\*), in every month (\*), on Saturday (6) run this command:

```bash
/usr/bin/python3 /home/azureuser/update_minecraft_server.py
```
