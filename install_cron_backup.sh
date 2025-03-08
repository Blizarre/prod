#!/bin/sh -eux

PROD_DIR="$(dirname "$(readlink -f "$0")")"

sudo tee /etc/cron.daily/prod_backup <<EOF
#!/bin/sh -eux
cd "$PROD_DIR"
docker compose run backup_restore backup
EOF
sudo chmod +x /etc/cron.daily/prod_backup
