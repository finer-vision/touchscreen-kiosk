#!/usr/bin/env bash

os=$(uname -s | awk '{print tolower($0)}')

if [[ ${machine} != "linux" ]]
then
    printf "Error: This script is only executable on a Linux machine\n"
    exit 1
fi

printf "Setting up system...\n"
DEBIAN_FRONTEND=noninteractive
curl -fsSL https://deb.nodesource.com/setup_16.x | bash -
sudo apt update -y
sudo apt install -y build-essential git nodejs unclutter xinput-calibrator chrome-gnome-shell teamviewer curl wget
sudo npm add -g pm2
pm2 startup
sudo env PATH=$PATH:/usr/bin /usr/lib/node_modules/pm2/bin/pm2 startup systemd -u fv --hp /home/fv
# Prevent software popup from showing
gsettings set com.ubuntu.update-notifier no-show-notifications true
printf "System setup complete\n"

printf "Installing Google Chrome...\n"
curl -s -O https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
dpkg -i google-chrome-stable_current_amd64.deb
printf "Google Chrome installation complete\n"

printf "Disabling touch gestures...\n"
wget https://extensions.gnome.org/extension-data/disable-gestures%40mattbell.com.au.v2.shell-extension.zip
gnome-extensions install -f disable-gestures@mattbell.com.au.v2.shell-extension.zip
gnome-extensions enable disable-gestures@mattbell.com.au
printf "Touch gestures disabled\n"

printf "Installing touchscreen-kiosk...\n";
wget https://github.com/finer-vision/touchscreen-kiosk/releases/download/v0.0.0/touchscreen-kiosk-linux
sudo mv touchscreen-kiosk-linux /usr/bin/touchscreen-kiosk
sudo chmod +x /usr/bin/touchscreen-kiosk
printf "touchscreen-kiosk installed\n"

printf "Cleaning up...\n"
rm -f google-chrome-stable_current_amd64.deb
rm -f disable-gestures@mattbell.com.au.v2.shell-extension.zip
printf "Finished\n"
