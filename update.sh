#!/bin/sh -eux

cd "$(dirname "$0")"

git pull
git submodule update --init --recursive
sudo docker-compose build --pull --parallel
sudo docker-compose down
sudo docker-compose up -d
