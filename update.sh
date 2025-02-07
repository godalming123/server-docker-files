sudo docker compose --project-directory caddy pull
sudo docker compose --project-directory caddy up --force-recreate -d

sudo docker compose --project-directory immich pull
sudo docker compose --project-directory immich up --force-recreate -d

sudo docker compose --project-directory jellyfin pull
sudo docker compose --project-directory jellyfin up --force-recreate -d

sudo docker compose --project-directory nextcloud pull
sudo docker compose --project-directory nextcloud up --force-recreate -d

sudo docker image prune -f
