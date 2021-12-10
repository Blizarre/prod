# `prepare_headless_pi_image.sh`

Used to generate a headless raspbian image with SSH+wifi enabled at startup.

# Reduce writes on the SD card

Disable swap:
```bash
sudo dphys-swapfile swapoff
sudo dphys-swapfile uninstall

sudo apt-get remove dphys-swapfile
```

Write logs and temporary files in ram by updating `/etc/fstab`:

```
tmpfs /var/log tmpfs nodev,nosuid,size=50M 0 0
tmpfs /tmp tmpfs nodev,nosuid,size=50M 0 0
```