#!/bin/sh -eux

cd "$(dirname "$0")"

sudo docker-compose run backup_restore backup