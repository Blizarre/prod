#!/usr/bin/bash

set -euo pipefail

HOST="${1?IP required}"

ssh-copy-id "pi@$HOST"

ssh "pi@$HOST" "sudo apt-get update && sudo apt-get -y dist-upgrade && sudo apt-get -y autoremove"
ssh "pi@$HOST" "sudo apt-get install -y cups && sudo usermod -a -G lpadmin pi"
ssh "pi@$HOST" "sudo cupsctl --remote-admin --remote-any --share-printers"
ssh "pi@$HOST" "sudo reboot" || true
while ! ssh "pi@$HOST" true; do echo "retrying"; sleep 5; done
echo "Setup and reboot ok"

# For home printer
# sudo apt-get install printer-driver-splix
# Add new printer wit hdriver Samsung ML-2165, 2.0.0

