# Server docker files
A collection of docker compose files that make it easy to setup a self-hosted home server with [Immich](https://immich.app/), [Jellyfin](https://jellyfin.org/), and [Nextcloud](https://nextcloud.com/).

# TODO
- Allow the usage of nextcloud with mySQL and mariaDB for more performance then SQLite
- Setup automatic backup and update for docker containers
- Add the option to not setup some of the containers
- Add the option to only allow certain twingate users access to certain apps

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
```
DB_PASSWORD=postgres # CHANGE THIS VALUE TO A RANDOM STRING OF LETTERS FOR SECURITY
DB_USERNAME=postgres
DB_DATABASE_NAME=immich
```

## 5. Upload your media to jellyfin
Create a `jellyfin/media` folder, and copy your media files there. If possible, try to convert media files to [a codec that is supported on all of the devices that you use](https://jellyfin.org/docs/general/clients/codec-support/) before you upload them. This means that the server does not have to convert the files to a codec that the client supports as the client is consuming them, which saves CPU, and can fix frame dropping issues. VLC media player can be used to do these conversions, although each file has to be manually converted.

## 6. Startup the containers
```sh
sudo docker compose --project-directory immich up -d
sudo docker compose --project-directory jellyfin up -d
sudo docker compose --project-directory nextcloud up -d
sudo docker compose --project-directory caddy up -d
```

## 7. Setup the containers
### Immich
Go to `https://imich.YOUR_DUCKDNS_DOMAIN.org/`, and setup your account. Immich has some AI features enabled out of the box that only ever run on the server, where the data is *never* sent to a third party. Howerver, this cuases the server to use 100% CPU until it has processed all of the photos that you upload when you import your photos and videos. These AI features can be disabled by pressing Administration -> Jobs -> Stop job.
### Nextcloud
Go to `https://nextcloud.YOUR_DUCKDNS_DOMAIN.org/`, and setup your account. Use the SQLite database (I cannot get any other DB to work).
### Jellyfin
Go to `http://jellyfin.YOUR_DUCKDNS_DOMAIN.org/web/index.html#!/wizardstart.html` and setup your account.

## 8. Setup automatic updates for your OS
Here is the command for debian:
```sh
sudo apt install unattended-upgrades
sudo systemctl enable --now unattended-upgrades
sudo dpkg-reconfigure -plow unattended-upgrades
```

## 9. OPTIONAL: Setup twingate so that the server can be accessed form outside your WiFi network
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
