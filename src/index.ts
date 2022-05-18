import puppeteer, { Browser } from "https://deno.land/x/puppeteer@9.0.2/mod.ts";
import { exists } from "https://deno.land/std@0.132.0/fs/mod.ts";
import os from "https://deno.land/x/dos@v0.11.0/mod.ts";

let browser: Browser;
let process: Deno.Process;

const homeDir = os.homeDir();

// Clean exit
const exit = async (code = 0) => {
  if (browser) await browser.close();
  if (process) {
    await process.kill("SIGINT");
    await process.close();
  }
  console.log("Kiosk exited");
  Deno.exit(code);
};

const executablePaths: { [os: string]: string } = {
  darwin: "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome",
  linux: "/usr/bin/google-chrome",
  win32: "C:\\Program Files (x86)\\Google\\Chrome\\Application\\chrome.exe",
  win64: "C:\\Program Files (x86)\\Google\\Chrome\\Application\\chrome.exe",
};

const executablePath = executablePaths[Deno.build.os];

// Is the OS supported?
if (!executablePath) {
  console.error(`Error: Unsupported OS "${Deno.build.os}"`);
  Deno.exit(1);
}

// Is Google Chrome installed?
if (!(await exists(executablePath))) {
  console.error(`Error: Chrome is not installed at path "${executablePath}"`);
  Deno.exit(1);
}

try {
  const { args } = Deno;

  const url = args
    .find((arg) => arg.startsWith("--url="))
    ?.replace("--url=", "");

  const start = args
    .find((arg) => arg.startsWith("--start="))
    ?.replace("--start=", "");

  // Has a url been provided?
  if (!url) {
    console.error(
      "Error: No --url flag, try again with --url=https://example.com"
    );
    Deno.exit(1);
  }

  if (start) {
    process = Deno.run({
      cmd: start.split(" "),
      stdout: "inherit",
    });
    await new Promise((resolve) => setTimeout(resolve, 1000));
  }

  const mode = args
    .find((arg) => arg.startsWith("--mode="))
    ?.replace("--mode=", "") ?? "production";

  const delayArg = args
    .find((arg) => arg.startsWith("--delay="))
    ?.replace("--delay=", "") ?? "0";
  let delay = parseInt(delayArg);
  if (isNaN(delay)) {
    delay = 0;
  }

  const browserArgs: string[] = [
    "--no-first-run",
    "--disable-pinch",
    "--no-default-check",
    "--overscroll-history-navigation=0",
    `--app=${url}`,
    "--autoplay-policy=no-user-gesture-required",
    "--start-fullscreen",
    "--remote-debugging-port=9222",
    `--user-data-dir=${homeDir}/kiosk`,
  ];

  if (mode === "production") {
    browserArgs.push("--kiosk")
  }

  await new Promise(resolve => setTimeout(resolve, delay));

  browser = await puppeteer.launch({
    headless: false,
    executablePath,
    args: browserArgs,
    ignoreDefaultArgs: [
      "--enable-automation",
      "--enable-blink-features=IdleDetection",
    ],
  });

  const context = browser.defaultBrowserContext();
  await context.clearPermissionOverrides();

  browser.on("disconnected", exit);
} catch (err) {
  console.error(`Error: ${err.message}`);
  await exit(1);
}
