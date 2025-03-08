#!/bin/sh -eux

cd "$(dirname "$0")"

docker compose run backup_restore backup
