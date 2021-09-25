#!/bin/sh -eux

cd "$(dirname "$0")"

sudo docker-compose stop wikijs bibin
sudo docker-compose run backup_restore restore
sudo docker-compose start wikijs bibin
