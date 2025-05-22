#!/usr/bin/env sh
./run-compose-command-for-every-container.sh pull
./run-compose-command-for-every-container.sh up --force-recreate -d
sudo docker image prune -f
