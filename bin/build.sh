#!/usr/bin/env bash

deno compile -A --unstable --target x86_64-unknown-linux-gnu --output touchscreen-kiosk-linux src/index.ts
deno compile -A --unstable --target x86_64-pc-windows-msvc --output touchscreen-kiosk-windows src/index.ts
deno compile -A --unstable --target x86_64-apple-darwin --output touchscreen-kiosk-macos src/index.ts
