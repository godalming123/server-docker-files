# Server docker files
A collection of docker compose files that make it easy to setup a self-hosted home server with [Immich](https://immich.app/), [Jellyfin](https://jellyfin.org/), and [Nextcloud](https://nextcloud.com/).

# TODO
- Allow the usage of nextcloud with mySQL and mariaDB for more performance
- Setup automatic backup and update for docker containers
- Setup caddy with duckDNS and optionally twingate so that the server is actually secure, and can be accessed from anywhere

# Usage

## 1. Install docker
[Docker engine install documentation](https://docs.docker.com/engine/install/)

## 2. Download the code
```sh
git clone https://github.com/godalming123/server-docker-files.git
```

### 3. Edit the immich DB password
`immich/.env`
```
DB_PASSWORD=postgres # CHANGE THIS VALUE TO A RANDOM STRING OF LETTERS FOR SECURITY
DB_USERNAME=postgres
DB_DATABASE_NAME=immich
```

### 4. Startup the containers
```sh
docker compose -dp immich
docker compose -dp jellyfin
docker compose -dp nextcloud
```

### 5. Setup the containers
#### Immich
Go to `http://THE.SERVERS.IP.ADDRESS:2283/`, and setup your account. Immich has some AI features enabled out of the box that only ever run on the server, where the data is *never* sent to a third party. Howerver, this cuases the server to use 100% CPU until it has processed all of the photos that you upload when you import your photos and videos. These AI features can be disabled by pressing Administration -> Jobs -> Stop job.
#### Nextcloud
Go to `https://THE.SERVERS.IP.ADDRESS:1234/`, click through the self-signed certificate warning, and setup your account. Use the SQLite database (I cannot get a different DB to work).
#### Jellyfin
Go to `http://THE.SERVERS.IP.ADDRESS:8096/web/index.html#!/wizardstart.html` and setup your account. When importing media, if possible, try to convert media files to a codec that is supported on all of the devices that you use before you upload them. This means that the server does not have to convert the files to a codec that the client supports as the client is consuming them, which saves CPU and can fix frame dropping issues. VLC media player can be used to do these conversions, although each file has to be manually converted.

### 6. Setup automatic updates for your OS
Here is the command for debian:
```sh
sudo apt install unattended-upgrades
sudo systemctl enable --now unattended-upgrades
sudo dpkg-reconfigure -plow unattended-upgrades
```
