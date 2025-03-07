#!/bin/bash

set -euxo pipefail

ACTION=${1-}

mkdir -p ~/.ssh
cp -r /ssh_host/* ~/.ssh/

if [[ "$ACTION" = "backup" ]]; then
    pg_dumpall --clean "--host=$POSTGRES_HOST" "--username=$POSTGRES_USER" | bzip2 > wiki_data.bz2
    scp wiki_data.bz2 hetzner:wiki_backup_$(date +"%u").bz2
    scp wiki_data.bz2 hetzner:wiki_backup_latest.bz2

    sqlite3 "$SQLITE_FILE" ".backup 'bibin_data.sqlite3'"
    bzip2 bibin_data.sqlite3
    scp bibin_data.sqlite3.bz2 hetzner:bibin_backup_$(date +"%u").bz2
    scp bibin_data.sqlite3.bz2 hetzner:bibin_backup_latest.bz2
elif [[ "$ACTION" = "restore" ]]; then
    ssh hetzner cat wiki_backup_latest.bz2 | \
        bunzip2 | \
        psql "--host=$POSTGRES_HOST" "--username=$POSTGRES_USER" postgres

    if ! test -f "$SQLITE_FILE"; then
      echo "Could not find an existing bibin db. Run bibin once first before starting a restore"
      exit 2
    fi
    # Remove any temporary file that might be there
    rm -f "$SQLITE_FILE"-*
    ssh hetzner cat bibin_backup_latest.bz2 | \
        bunzip2 > "$SQLITE_FILE"
else
    echo "Nothing to do"
fi
