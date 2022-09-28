#!/usr/bin/env bash

printf "Setting up system...\n"
curl -fsSL https://deb.nodesource.com/setup_16.x | bash -
sudo apt update -y
sudo apt install -y dbus-x11 build-essential git nodejs unclutter xinput-calibrator chrome-gnome-shell libminizip1 libxcb-xinerama0 curl wget gnome-shell-extension-prefs
curl https://download.teamviewer.com/download/linux/teamviewer_amd64.deb
sudo dpkg -i teamviewer_*.deb
sudo npm add -g pm2 serve
# node app manager
pm2 startup
sudo env PATH=$PATH:/usr/bin /usr/lib/node_modules/pm2/bin/pm2 startup systemd -u $USER --hp /home/$USER
pm2 save --force
# Prevent software popup from showing
gsettings set com.ubuntu.update-notifier no-show-notifications true
# Prevent display from turning off
gsettings set org.gnome.settings-daemon.plugins.power idle-dim true
mkdir /home/$USER/apps
ssh-keygen -q -t rsa -N '' -f /home/$USER/.ssh/id_rsa <<<y
printf "System setup complete\n"

printf "Installing Google Chrome...\n"
curl -s -O https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
dpkg -i google-chrome-stable_current_amd64.deb
printf "Google Chrome installation complete\n"

printf "Installing touchscreen-kiosk...\n";
wget https://github.com/finer-vision/touchscreen-kiosk/releases/download/v0.0.0/touchscreen-kiosk-linux
sudo mv touchscreen-kiosk-linux /usr/bin/touchscreen-kiosk
sudo chmod +x /usr/bin/touchscreen-kiosk
printf "touchscreen-kiosk installed\n"

printf "Disabling touch gestures...\n"
wget -c https://extensions.gnome.org/extension-data/disable-gestures-2021verycrazydog.gmail.com.v4.shell-extension.zip
gnome-extensions install -f disable-gestures-2021verycrazydog.gmail.com.v4.shell-extension.zip
gnome-extensions enable disable-gestures-2021@verycrazydog.gmail.com
printf "Touch gestures disabled\n"

printf "Cleaning up...\n"
rm -f google-chrome-stable_current_amd64.deb
rm -f disable-gestures-2021verycrazydog.gmail.com.v4.shell-extension.zip
rm -f teamviewer_*.deb
# Reload GNOME shell
killall -3 gnome-shell
printf "Finished\n"

printf "Add this deploy key to the GitHub repo you want to clone:\n"
cat /home/$USER/.ssh/id_rsa.pub
