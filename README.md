# Touchscreen Kiosk

Touchscreen kiosk runner executable.

# Kiosk Install

The below steps will provision a plug 'n' play kiosk touchscreen, running on Ubuntu 20.04.

```shell
sudo apt update -y
sudo apt install -y curl
curl -fsSL https://raw.githubusercontent.com/finer-vision/touchscreen-kiosk/main/bin/install-20.04.sh | sudo -S -i -u $USER bash -s
```

The below steps will provision a plug 'n' play kiosk touchscreen, running on Ubuntu 22.04.

```shell
sudo apt update -y
sudo apt install -y curl
curl -fsSL https://raw.githubusercontent.com/finer-vision/touchscreen-kiosk/main/bin/install-22.04.sh | sudo -S -i -u $USER bash -s
```

Open TeamViewer:

1. Go to `Extras` > `Options` and tick "Start TeamViewer with system"
2. Go to `Security` and click "Grant easy access"

Copy the public key to the GitHub repository:

[https://github.com/finer-vision/repo/settings/keys](https://github.com/finer-vision/repo/settings/keys)

Clone an app into the `/home/$USER/apps` directory:

```shell
cd /home/$USER/apps
git clone git@github.com:finer-vision/repo.git
```

Start the app when the system starts:

```shell
# Run the app
pm2 start --name kiosk /usr/bin/touchscreen-kiosk -- --url=http://localhost:3000 --start="node /home/$USER/apps/repo/server/build/index.js" --delay=3000
# Save the app so it starts with the system
pm2 save
```

Restart the system and the app should automatically run when the system starts.

---

# Development

### Software

- deno 1.20.3

### Usage

```shell
touchscreen-kiosk --url=https://example.com --start="node ~/apps/repo/build/index.js" --mode=debug
```

### Getting Started

```shell
deno cache --unstable src/index.ts
deno run -A --unstable src/index.ts
```

### Compile & Release

```shell
./bin/build.sh
./bin/release.sh
```

### Debugging

Open a new Google Chrome window and visit [chrome://inspect/#pages](chrome://inspect/#pages),
then click `inspect` on the page running the app.

### Touchscreen Notes

If you need portrait instead of the default landscape orientation, run these two commands when the machine first loads into the desktop. Note, this will reset on reboot, so make sure you run the each time the touchscreen starts.

```shell
#!/usr/bin/env bash
sleep 5
INPUT_DEVICE=$(xinput list | awk -F'[=\t]' '/HID.*pointer/ {print $3; exit}')
OUTPUT_DEVICE=$(xrandr | grep -w connected | awk '{print $1}')
xrandr -o left
xinput map-to-output $INPUT_DEVICE $OUTPUT_DEVICE
/usr/bin/touchscreen-kiosk \
	--url=http://localhost:3000 \
	--start="serve -s -p 3000 -d /home/$USER/apps/repo/build"
```

### Disable Screen Keyboard

```shell
wget https://github.com/lxylxy123456/cariboublocker/releases/download/auto-release-7cbc3f1582f3848995ba3c985efd26b911a33af9/3.36.3.zip -O block-caribou-36@lxylxy123456.ercli.dev.zip
gnome-extensions install -f block-caribou-36@lxylxy123456.ercli.dev.zip
gnome-extensions enable block-caribou-36@lxylxy123456.ercli.dev
```
