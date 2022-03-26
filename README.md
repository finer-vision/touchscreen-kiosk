# Touchscreen Kiosk

Touchscreen kiosk runner executable.

### Getting Started

```shell
deno cache --unstable src/index.ts
deno run -A --unstable src/index.ts
```

### Compile Executable

```shell
deno compile -A --unstable --output touchscreen-kiosk src/index.ts
```

### Executable Usage

```shell
./touchscreen-kiosk --url=https://example.com
```
