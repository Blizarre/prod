#!/bin/sh -eux

cd "$(dirname "$0")"

git pull
git submodule update --init --recursive
(cd ./marache.net/ && hugo)
sudo docker-compose build
sudo docker-compose down
sudo docker-compose up -d
