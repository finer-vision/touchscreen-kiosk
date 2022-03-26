# Touchscreen Kiosk

Touchscreen kiosk runner executable.

### Getting Started

```shell
deno cache --unstable src/index.ts
deno run -A --unstable src/index.ts
```

### Compile Executable

```shell
./bin/build.sh
```

### Executable Usage

```shell
./touchscreen-kiosk --url=https://example.com
```

### Debugging

Open a new Google Chrome window and visit [chrome://inspect/#pages](chrome://inspect/#pages),
then click `inspect` on the page running the app.
