#!/bin/sh -eux

cd "$(dirname "$0")"

sudo docker volume create --name=bibin_data
sudo docker volume create --name=caddy_data
sudo docker volume create --name=caddy_config
sudo docker volume create --name=wikijs_data

sudo docker-compose build
sudo docker run -v bibin_data:/data --entrypoint /bin/bash --user root prod_bibin -c "chown -R nobody /db"