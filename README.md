# Touchscreen Kiosk

Touchscreen kiosk runner executable.

### Installing Kiosk

On an Ubuntu machine, run the following.

```shell
sudo apt-get update -y
sudo apt-get install -y curl
curl -sf -L https://raw.githubusercontent.com/finer-vision/touchscreen-kiosk/main/bin/install.sh | sudo sh
```

Open TeamViewer:

1. Go to `Extras` > `Options` and tick "Start TeamViewer with system"
2. Go to `Security` and click "Grant easy access"

Generate SSH key:

```shell
ssh-keygen -q -t rsa -N '' -f /home/fv/.ssh/id_rsa <<<y
cat /home/fv/.ssh/id_rsa.pub
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
pm2 start --name kiosk /usr/bin/touchscreen-kiosk -- --url="https://example.com"
# Save the app so it starts with the system
pm2 save
```

Restart the system and the app should automatically run when the system starts.

Finally, go to `Settings` > `Power` and make sure the computer never goes to sleep and the screen never dims.

---

### Usage

```shell
./touchscreen-kiosk --url=https://example.com
```

### Getting Started (Development)

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
