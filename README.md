# Touchscreen Kiosk

Touchscreen kiosk runner executable.

# Kiosk Install

The below steps will provision a plug 'n' play kiosk touchscreen, running on Ubuntu.

```shell
sudo apt update -y
sudo apt install -y curl
curl -fsSL https://github.com/finer-vision/touchscreen-kiosk/raw/main/bin/install.sh | sudo sh
```

Open TeamViewer:

1. Go to `Extras` > `Options` and tick "Start TeamViewer with system"
2. Go to `Security` and click "Grant easy access"

Generate SSH key:

```shell
ssh-keygen -q -t rsa -N '' -f /home/$USER/.ssh/id_rsa <<<y
cat /home/$USER/.ssh/id_rsa.pub
```

Copy the public key to the GitHub repository:

https://github.com/finer-vision/repo/settings/keys

Create a directory to house all apps:

```shell
mkdir ~/apps
cd ~/apps
```

Clone an app into the `apps` directory:

```shell
git clone git@github.com:finer-vision/repo.git
```

Start the app when the system starts:

```shell
# Run the app
pm2 start --name kiosk /usr/bin/touchscreen-kiosk -- --url=http://localhost:3000 --start="node /home/$USER/apps/repo/server/build/index.js"
# Save the app so it starts with the system
pm2 save
```

Restart the system and the app should automatically run when the system starts.

Finally, go to `Settings` > `Power` and make sure the computer never goes to sleep and the screen never dims.

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
