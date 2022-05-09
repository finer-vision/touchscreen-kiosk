#!/usr/bin/env bash

printf "Setting up system...\n"
curl -fsSL https://deb.nodesource.com/setup_16.x | bash -
sudo apt update -y
sudo apt install -y build-essential git nodejs unclutter xinput-calibrator chrome-gnome-shell teamviewer curl wget gnome-tweaks
sudo npm add -g pm2
pm2 startup
sudo env PATH=$PATH:/usr/bin /usr/lib/node_modules/pm2/bin/pm2 startup systemd -u $USER --hp /home/$USER
# Prevent software popup from showing
gsettings set com.ubuntu.update-notifier no-show-notifications true
printf "System setup complete\n"

printf "Installing Google Chrome...\n"
curl -s -O https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
dpkg -i google-chrome-stable_current_amd64.deb
printf "Google Chrome installation complete\n"

printf "Disabling touch gestures...\n"
wget -c https://extensions.gnome.org/extension-data/disable-gestures-2021verycrazydog.gmail.com.v4.shell-extension.zip -O disable-gestures.zip
gnome-extensions install -f disable-gestures.zip
gnome-extensions enable disable-gestures-2021@verycrazydog.gmail.com
printf "Touch gestures disabled\n"

printf "Installing touchscreen-kiosk...\n";
wget https://github.com/finer-vision/touchscreen-kiosk/releases/download/v0.0.0/touchscreen-kiosk-linux
sudo mv touchscreen-kiosk-linux /usr/bin/touchscreen-kiosk
sudo chmod +x /usr/bin/touchscreen-kiosk
printf "touchscreen-kiosk installed\n"

printf "Cleaning up...\n"
rm -f google-chrome-stable_current_amd64.deb
rm -f disable-gestures.zip
printf "Finished\n"
