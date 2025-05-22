#!/usr/bin/env sh
sudo docker compose --project-directory caddy "$@"
sudo docker compose --project-directory immich "$@"
sudo docker compose --project-directory jellyfin "$@"
sudo docker compose --project-directory nextcloud "$@"
