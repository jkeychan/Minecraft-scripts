import requests
from bs4 import BeautifulSoup
import re
import os
import logging


def setup_logging(log_dir, log_file):
    if not os.path.exists(log_dir):
        os.makedirs(log_dir)
    logging.basicConfig(level=logging.INFO,
                        format='%(asctime)s %(levelname)s: %(message)s',
                        datefmt='%Y-%m-%d %H:%M:%S',
                        handlers=[logging.FileHandler(os.path.join(log_dir, log_file)),
                                  logging.StreamHandler()])


def get_latest_version_info(download_page_url):
    headers = {
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.3',
        'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8',
        'Accept-Language': 'en-US,en;q=0.5',
        'Accept-Encoding': 'gzip, deflate, br'
    }
    response = requests.get(download_page_url, headers=headers, timeout=10)
    if response.status_code == 200:
        soup = BeautifulSoup(response.content, 'html.parser')
        link = soup.find('a', {
                         "aria-label": re.compile(r"minecraft version|mincraft version", re.IGNORECASE)})
        if link and 'href' in link.attrs:
            file_url = link['href']
            version_match = re.search(
                r'minecraft_server\.(\d+\.\d+\.\d+)\.jar', link.text)
            if version_match:
                return file_url, f"minecraft_server-{version_match.group(1)}.jar"
    return None, None


def download_file(url, path):
    response = requests.get(url)
    if response.status_code == 200:
        with open(path, 'wb') as file:
            file.write(response.content)
        return True
    return False


def main():
    download_page_url = "https://www.minecraft.net/en-us/download/server"
    server_dir = "/home/azureuser/MC"
    old_jars_dir = os.path.join(server_dir, "old-jars")
    log_path = "/home/azureuser/MC/logs"
    current_version_link = os.path.join(server_dir, "server.jar")
    setup_logging(log_path, "minecraft-update.log")

    # Check if the log directory exists, if not, create it
    if not os.path.exists(log_path):
        os.makedirs(log_path)

    # Check if the old jars directory exists, if not, create it
    if not os.path.exists(old_jars_dir):
        os.makedirs(old_jars_dir)

    file_url, file_name = get_latest_version_info(download_page_url)
    if file_url and file_name:
        new_jar_path = os.path.join(server_dir, file_name)
        if not os.path.exists(new_jar_path):
            logging.info(f"Downloading new version: {file_name}")
            if not download_file(file_url, new_jar_path):
                logging.error("Failed to download the new server version.")
                return
            if os.path.islink(current_version_link):
                old_version_path = os.readlink(current_version_link)
                if old_version_path:
                    old_jar_path = os.path.join(server_dir, old_version_path)
                    if os.path.exists(old_jar_path):
                        os.rename(old_jar_path, os.path.join(
                            old_jars_dir, os.path.basename(old_version_path)))
                        logging.info(f"Archived old version to {old_jars_dir}")
            if os.path.exists(current_version_link) or os.path.islink(current_version_link):
                os.remove(current_version_link)
            os.symlink(new_jar_path, current_version_link)
            logging.info("Minecraft server updated successfully.")
            # subprocess.run("sudo systemctl restart minecraft", shell=True)
        else:
            logging.info("The latest version is already installed.")
    else:
        logging.error(
            "Failed to obtain the latest server version information.")


if __name__ == "__main__":
    main()
