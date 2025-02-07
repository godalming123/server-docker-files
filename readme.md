# Server docker files

A collection of docker compose files that make it easy to setup a self-hosted home server with [Immich](https://immich.app/), [Jellyfin](https://jellyfin.org/), and [Nextcloud](https://nextcloud.com/).

# To do

- Setup automatic backup and update for docker containers
- Add the option to not setup some of the containers
- Add the option to only allow certain twingate users access to certain apps
- Switch from [an unofficial nextcloud image](https://hub.docker.com/_/nextcloud) to [the official nextcloud image](https://hub.docker.com/r/nextcloud/all-in-one), since the unofficial image [has vulnerabilities](https://hub.docker.com/_/nextcloud/tags)
- Fix the `update.sh` script so that it works from any folder

# Usage

## 1. Install docker

[Docker engine install documentation](https://docs.docker.com/engine/install/)

## 2. Download the code

```sh
git clone https://github.com/godalming123/server-docker-files.git
cd server-docker-files
```

## 3. Setup encryption with trusted SSL certificates using duckDNS and caddy

1. Go to https://duckdns.org, and create an account with one domain for your server which has the `current_ip` option set to the IP address of your server
2. Edit `caddy/Caddyfile`, and enter your duckDNS token (can be found on the duckDNS website when you are signed in), and your domain

## 4. Edit the immich DB password

`immich/.env`

```env
DB_PASSWORD=postgres # CHANGE THIS VALUE TO A RANDOM STRING OF LETTERS FOR SECURITY
DB_USERNAME=postgres
DB_DATABASE_NAME=immich
```

## 5. Edit the nextcloud `.env` file

`nextcloud/.env`

```env
MYSQL_ROOT_PASSWORD=CHANGE_THE_ROOT_PASSWORD_TO_A_RANDOM_STRING
MYSQL_PASSWORD=CHANGE_THE_PASSWORD_TO_A_RANDOM_STRING
MYSQL_DATABASE=nextcloud
MYSQL_USER=nextcloud
MYSQL_HOST=db
OVERWRITECLIURL="https://nextcloud.<YOUR_DUCKDNS_DOMAIN>.duckdns.org"
OVERWRITEPROTOCOL="https"
```

## 6. Upload your media to jellyfin

Create a `jellyfin/media` folder, and copy your media files there. If possible, try to convert media files to [a codec that is supported on all of the devices that you use](https://jellyfin.org/docs/general/clients/codec-support/) before you upload them. This means that the server does not have to convert the files to a codec that the client supports as the client is consuming them, which saves CPU, and can fix frame dropping issues. VLC media player can be used to do these conversions, although each file has to be manually converted.

## 7. Startup the containers

```sh
sudo docker compose --project-directory immich up -d
sudo docker compose --project-directory jellyfin up -d
sudo docker compose --project-directory nextcloud up -d
sudo docker compose --project-directory caddy up -d
```

## 8. Setup the containers

### Immich

Go to `https://imich.YOUR_DUCKDNS_DOMAIN.org/`, and setup your account. Immich has some AI features enabled out of the box that only ever run on the server, where the data is _never_ sent to a third party. Howerver, this cuases the server to use 100% CPU until it has processed all of the photos that you upload when you import your photos and videos. These AI features can be disabled by pressing Administration -> Jobs -> Stop job.

### Nextcloud

Go to `https://nextcloud.YOUR_DUCKDNS_DOMAIN.org/`, and setup your account.

### Jellyfin

Go to `http://jellyfin.YOUR_DUCKDNS_DOMAIN.org/web/index.html#!/wizardstart.html` and setup your account.

## 9. Setup automatic updates for your OS

Here is the command for debian:

```sh
sudo apt install unattended-upgrades
sudo systemctl enable --now unattended-upgrades
sudo dpkg-reconfigure -plow unattended-upgrades
```

## 10. OPTIONAL: Setup twingate so that the server can be accessed from outside your WiFi network

Go to https://auth.twingate.com/signup-v2, and:

1. Create a twingate account
2. Setup a resoarce (with your server's IP address as a URL) and connector for your server
3. Edit `twingate/docker-compose.yml` with the following contents:
   ```yaml
   name: twingate
   services:
     twingate_connector:
       container_name: twingate_connector
       image: twingate/connector:latest
       environment:
         - TWINGATE_NETWORK=<ADD_YOUR_NETWORK_NAME_HERE>
         - TWINGATE_ACCESS_TOKEN=<ADD_YOUR_ACCESS_TOKEN_HERE>
         - TWINGATE_REFRESH_TOKEN=<ADD_YOUR_REFRESH_TOEKN_HERE>
       restart: unless-stopped
   ```
4. Run docker compose up
   ```sh
   sudo docker compose --project-directory twingate up -d
   ```
5. Install twingate and sign in on the client that you want to access the network with
6. Add twingate to the `update.sh` script:
   ```diff
   sudo docker compose --project-directory nextcloud pull
   sudo docker compose --project-directory nextcloud up --force-recreate -d

   +sudo docker compose --project-directory twingate pull
   +sudo docker compose --project-directory twingate up --force-recreate -d
   +
   sudo docker image prune -f
   ```

## 11. Update your docker compose containers

To update every docker container, run the `update.sh` script from the `server-docker-files` folder.

<details>
<summary>How to update docker containers individually</summary>

Run the following commands from the folders with the docker compose file in:

```sh
sudo docker compose pull
sudo docker compose up --force-recreate -d
sudo docker image prune -f
```

</details>
