#!/bin/sh -eux

cd "$(dirname "$0")"

git submodule init
git submodule update

### Install docker and packages
sudo apt-get -y remove docker docker-engine docker.io containerd runc || true
sudo apt-get -y remove snapd
sudo apt -y autoremove

sudo apt-get -y install apt-transport-https ca-certificates curl gnupg lsb-release tmux vim htop
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --yes --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

echo \
  "deb [arch=arm64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update
sudo apt-get -y dist-upgrade
sudo apt-get -y install docker-ce docker-ce-cli containerd.io docker-compose
#### End of package installation

sudo docker volume create --name=bibin_data
sudo docker volume create --name=caddy_data
sudo docker volume create --name=caddy_config
sudo docker volume create --name=wikijs_data

sudo docker-compose build

sudo docker run -v bibin_data:/db --entrypoint /bin/bash --user root prod_bibin -c "chown -R nobody /db"
sudo docker-compose up -d
./install_cron_backup.sh
