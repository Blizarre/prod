#!/usr/bin/bash

# Automate the creation of a headless raspberry pi image (ssh + wifi connectivity at boot)
# https://www.raspberrypi.com/documentation/computers/configuration.html#setting-up-a-headless-raspberry-pi

set -euo pipefail

# The image is very big and migh not fit in /tmp
TEMP_DIR="$(dirname "$0")/temp_rapberry_image"

if losetup -l | grep /dev/loop0; then
  echo "/dev/loop0 busy, detach with 'sudo losetup -d /dev/loop0'"
  echo "You might need to unmount temp_rapberry_image/boot/"
  exit 1
fi
if test -d "$TEMP_DIR"; then
  echo "There is already a $TEMP_DIR directory in place, please remove"
  echo "it before proceeding"
  exit 1
fi

mkdir "$TEMP_DIR"

IMAGE_URL="${1?URL image required}"
WIFI_SSID="${2?WIFI SSID required}"
WIFI_PASSWORD="${3?WIFI PASSWORD required}"
WIFI_COUNTRY_CODE="${4?WIFI COUNTRY CODE required}"

pushd "$TEMP_DIR"
curl -L -o image.zip "$IMAGE_URL"
unzip image.zip
rm image.zip

IMAGE_FILE="$(ls *.img)"

echo "Preparing image $IMAGE_FILE"
sudo losetup -P /dev/loop0 "$IMAGE_FILE"

mkdir -p boot
sudo mount /dev/loop0p1 boot

# Enable ssh at startup
sudo touch ./boot/ssh
# Enabble wifi connectivity at startup

sudo tee boot/wpa_supplicant.conf <<EOF
ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
country=$WIFI_COUNTRY_CODE
update_config=1

network={
 ssid="$WIFI_SSID"
 psk="$WIFI_PASSWORD"
}
EOF

sudo umount boot
sudo losetup -d /dev/loop0

echo "Image ready in $TEMP_DIR/$IMAGE_FILE"
echo "Install it on the image with a command-line like"
echo "pv $TEMP_DIR/$IMAGE_FILE | sudo tee /dev/sdb > /dev/null"