import puppeteer, { Browser } from "https://deno.land/x/puppeteer@9.0.2/mod.ts";
import { exists } from "https://deno.land/std@0.132.0/fs/mod.ts";
import { exec } from "https://deno.land/x/exec@0.0.5/mod.ts";

let browser: Browser;

// Clean exit
const exit = async (code = 0) => {
  if (browser) await browser.close();
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
    exec(start).catch((err) => {
      console.error(`Error: ${err.message}`);
      Deno.exit(1);
    });
    await new Promise((resolve) => setTimeout(resolve, 1000));
  }

  browser = await puppeteer.launch({
    headless: false,
    executablePath,
    args: [
      "--no-first-run",
      "--disable-pinch",
      "--no-default-check",
      "--overscroll-history-navigation=0",
      `--app=${url}`,
    ],
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
