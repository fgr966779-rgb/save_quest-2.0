import { createServer } from 'http';
import { WebSocketServer } from 'ws';
import screenshot from 'screenshot-desktop';
import sharp from 'sharp';
import crypto from 'crypto';
import { exec } from 'child_process';
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const PORT = 8080;
const PASSWORD = 'cybervault'; // Default secure password, can be changed here

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);
const rootEnvPath = path.resolve(__dirname, '..', '.env');

function loadEnvFile(envPath) {
  try {
    const content = fs.readFileSync(envPath, 'utf8');
    const parsed = {};
    for (const line of content.split(/\r?\n/)) {
      const trimmed = line.trim();
      if (!trimmed || trimmed.startsWith('#')) continue;
      const equalsIndex = trimmed.indexOf('=');
      if (equalsIndex === -1) continue;
      const key = trimmed.slice(0, equalsIndex).trim();
      const value = trimmed.slice(equalsIndex + 1).trim();
      if (key) parsed[key] = value;
    }
    return parsed;
  } catch {
    return {};
  }
}

const fileEnv = loadEnvFile(rootEnvPath);
const serpApiKey = process.env.SERPAPI_KEY || fileEnv.SERPAPI_KEY || '';

let robot;
try {
  robot = (await import('robotjs')).default;
  console.log("Successfully loaded 'robotjs' for native input emulation.");
} catch (e) {
  console.log("------------------------------------------------------------------");
  console.log("WARNING: 'robotjs' is not installed or failed to compile.");
  console.log("Falling back to pure Win32 API calls via PowerShell for inputs.");
  console.log("This allows full remote control without native C compilation!");
  console.log("------------------------------------------------------------------");
}

// Global screen resolution cache
let screenWidth = 1920;
let screenHeight = 1080;

// Query actual screen size on Windows dynamically
exec("powershell -Command \"Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.Screen]::PrimaryScreen.Bounds.Width; [System.Windows.Forms.Screen]::PrimaryScreen.Bounds.Height\"", (err, stdout) => {
  if (!err && stdout) {
    const parts = stdout.trim().split(/\s+/);
    if (parts.length >= 2) {
      screenWidth = parseInt(parts[0], 10) || 1920;
      screenHeight = parseInt(parts[1], 10) || 1080;
      console.log(`[HOST] Active screen boundaries set to: ${screenWidth}x${screenHeight}`);
    }
  }
});

const server = createServer(async (req, res) => {
  const url = new URL(req.url, `http://${req.headers.host || `127.0.0.1:${PORT}`}`);

  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type');

  if (req.method === 'OPTIONS') {
    res.writeHead(204);
    res.end();
    return;
  }

  if (url.pathname === '/price-analysis') {
    const query = (url.searchParams.get('query') || url.searchParams.get('q') || '').trim();
    if (!query) {
      res.writeHead(200, { 'Content-Type': 'text/html; charset=utf-8' });
      res.end(`<!doctype html>
<html lang="en">
  <head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>PiggyVault Price Proxy</title>
    <style>
      body {
        font-family: Arial, sans-serif;
        background: #111;
        color: #f5f5f5;
        margin: 0;
        padding: 24px;
      }
      .card {
        max-width: 640px;
        background: #1b1b1f;
        border: 1px solid #2f2f35;
        border-radius: 16px;
        padding: 20px;
      }
      code {
        background: #0f0f12;
        padding: 2px 6px;
        border-radius: 6px;
      }
      a { color: #7b7bff; }
    </style>
  </head>
  <body>
    <div class="card">
      <h1>PiggyVault Price Proxy</h1>
      <p>This endpoint is used by the Flutter app to fetch live shopping prices.</p>
      <p>Try a direct example:</p>
      <p><code>/price-analysis?query=PS5</code></p>
      <p>Supported targets: PS5, 27 inch monitor, gaming monitor.</p>
      <p><a href="/price-analysis?query=PS5">Open PS5 example</a></p>
    </div>
  </body>
</html>`);
      return;
    }

    if (!serpApiKey) {
      res.writeHead(503, { 'Content-Type': 'application/json; charset=utf-8' });
      res.end(JSON.stringify({ error: 'SERPAPI_KEY is not configured on the proxy server' }));
      return;
    }

    try {
      const serpUrl = new URL('https://serpapi.com/search.json');
      serpUrl.searchParams.set('engine', 'google_shopping');
      serpUrl.searchParams.set('q', query);
      serpUrl.searchParams.set('gl', url.searchParams.get('gl') || 'ua');
      serpUrl.searchParams.set('hl', url.searchParams.get('hl') || 'uk');
      serpUrl.searchParams.set('num', url.searchParams.get('num') || '10');
      serpUrl.searchParams.set('api_key', serpApiKey);

      const response = await fetch(serpUrl);
      const body = await response.text();
      res.writeHead(response.status, { 'Content-Type': 'application/json; charset=utf-8' });
      res.end(body);
    } catch (error) {
      res.writeHead(502, { 'Content-Type': 'application/json; charset=utf-8' });
      res.end(JSON.stringify({
        error: 'Failed to fetch live market prices',
        details: error instanceof Error ? error.message : String(error),
      }));
    }

    return;
  }

  res.writeHead(404, { 'Content-Type': 'application/json; charset=utf-8' });
  res.end(JSON.stringify({ error: 'Not found' }));
});

const wss = new WebSocketServer({ server });
server.listen(PORT);
console.log(`\n=============================================================`);
console.log(`⚡ PIGGYVAULT REMOTE PC SERVER RUNNING ON PORT ${PORT} ⚡`);
console.log(`🔐 Authentication Password: "${PASSWORD}"`);
console.log(`=============================================================\n`);

wss.on('connection', (ws, req) => {
  const clientIp = req.socket.remoteAddress;
  console.log(`[CONN] New client connecting from: ${clientIp}`);

  // Generate a cryptographically secure random challenge salt
  const salt = crypto.randomBytes(16).toString('hex');
  let isAuthenticated = false;
  let isStreaming = false;
  let jpegQuality = 60; // Default compression quality

  // Handshake timeout: 15 seconds to authenticate
  const authTimeout = setTimeout(() => {
    if (!isAuthenticated) {
      console.log(`[AUTH] Client ${clientIp} failed to authenticate in time. Disconnecting...`);
      ws.close();
    }
  }, 15000);

  // Send the challenge
  ws.send(JSON.stringify({ type: 'challenge', salt }));

  ws.on('message', async (message, isBinary) => {
    if (isBinary) return; // Inputs should be text messages

    try {
      const data = JSON.parse(message.toString());

      // 1. Authentication Check
      if (!isAuthenticated) {
        if (data.type === 'auth') {
          const expectedHash = crypto
            .createHash('sha256')
            .update(PASSWORD + salt)
            .digest('hex');

          if (data.hash === expectedHash) {
            isAuthenticated = true;
            clearTimeout(authTimeout);
            console.log(`[AUTH] Success! Secure connection established with ${clientIp}`);
            ws.send(JSON.stringify({ type: 'auth_success' }));

            // Start screen capture loop
            startCaptureLoop();
          } else {
            console.log(`[AUTH] Rejected login attempt from ${clientIp}. Bad PIN/Password.`);
            ws.send(JSON.stringify({ type: 'auth_failure', reason: 'Invalid password' }));
            ws.close();
          }
        }
        return;
      }

      // 2. Process Control Actions
      switch (data.type) {
        case 'set_quality':
          jpegQuality = Math.max(10, Math.min(100, data.quality || 60));
          break;

        case 'mouse_move': {
          const rx = Math.round(data.x * screenWidth);
          const ry = Math.round(data.y * screenHeight);
          if (robot) {
            robot.moveMouse(rx, ry);
          } else {
            exec(`powershell -Command "[Void][System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms'); [System.Windows.Forms.Cursor]::Position = New-Object System.Drawing.Point(${rx}, ${ry})"`);
          }
          break;
        }

        case 'mouse_click': {
          const button = data.button || 'left';
          const isDouble = data.double || false;
          if (robot) {
            robot.mouseClick(button, isDouble);
          } else {
            const btnFlags = button === 'left' 
              ? '0x02 -bor 0x04' // LEFTDOWN | LEFTUP
              : '0x08 -bor 0x10'; // RIGHTDOWN | RIGHTUP
            const clickCode = `
              $signature = '[DllImport("user32.dll")] public static extern void mouse_event(int dwFlags, int dx, int dy, int dwData, int dwExtraInfo);'
              $type = Add-Type -MemberDefinition $signature -Name "Win32Mouse" -Namespace "Win32" -PassThru
              $type::mouse_event(${btnFlags}, 0, 0, 0, 0)
              ${isDouble ? `[System.Threading.Thread]::Sleep(100); $type::mouse_event(${btnFlags}, 0, 0, 0, 0)` : ''}
            `;
            exec(`powershell -Command "${clickCode.replace(/\n/g, ' ')}"`);
          }
          break;
        }

        case 'mouse_scroll': {
          const dy = data.dy || 0;
          if (robot) {
            // robotjs scroll: dy > 0 is up, dy < 0 is down
            robot.scrollMouse(0, dy);
          } else {
            const scrollCode = `
              $signature = '[DllImport("user32.dll")] public static extern void mouse_event(int dwFlags, int dx, int dy, int dwData, int dwExtraInfo);'
              $type = Add-Type -MemberDefinition $signature -Name "Win32Mouse" -Namespace "Win32" -PassThru
              $type::mouse_event(0x0800, 0, 0, ${dy}, 0) # 0x0800 is MOUSEEVENTF_WHEEL
            `;
            exec(`powershell -Command "${scrollCode.replace(/\n/g, ' ')}"`);
          }
          break;
        }

        case 'key_press': {
          const rawKey = data.key.toLowerCase();
          const mods = data.modifiers || []; // e.g. ["ctrl", "alt"]
          
          if (robot) {
            try {
              robot.keyTap(rawKey, mods);
            } catch (err) {
              console.log(`[KEY] RobotJS failed to tap key: ${rawKey}. Falling back.`);
            }
          } else {
            // Emulate keyboard input via PowerShell
            let sendKey = rawKey;
            // Map common modifier syntax
            if (rawKey === 'enter') sendKey = '{ENTER}';
            else if (rawKey === 'backspace') sendKey = '{BACKSPACE}';
            else if (rawKey === 'escape') sendKey = '{ESC}';
            else if (rawKey === 'tab') sendKey = '{TAB}';
            else if (rawKey === 'up') sendKey = '{UP}';
            else if (rawKey === 'down') sendKey = '{DOWN}';
            else if (rawKey === 'left') sendKey = '{LEFT}';
            else if (rawKey === 'right') sendKey = '{RIGHT}';
            else if (rawKey.length === 1) {
              // Standard character, enclose in brackets if it's a special character in SendKeys
              if ('+^%~()[]{}'.indexOf(rawKey) !== -1) {
                sendKey = `{${rawKey}}`;
              }
            }

            // Build modifier prefix
            let prefix = '';
            if (mods.includes('ctrl')) prefix += '^';
            if (mods.includes('shift')) prefix += '+';
            if (mods.includes('alt')) prefix += '%';

            const kbCode = `
              $wshell = New-Object -ComObject Wscript.Shell;
              $wshell.SendKeys('${prefix}${sendKey}');
            `;
            exec(`powershell -Command "${kbCode.replace(/\n/g, ' ')}"`);
          }
          break;
        }
      }
    } catch (e) {
      console.error(`[ERR] Failed to process incoming socket message:`, e);
    }
  });

  // Screen streaming loop
  async function startCaptureLoop() {
    isStreaming = true;
    console.log(`[STREAM] Initializing video capture feed...`);

    while (isAuthenticated && isStreaming && ws.readyState === ws.OPEN) {
      const startTime = Date.now();
      try {
        // 1. Grab screen screenshot
        const imgBuffer = await screenshot({ format: 'png' });

        // 2. Compress image using sharp
        const jpegBuffer = await sharp(imgBuffer)
          .jpeg({ quality: jpegQuality })
          .toBuffer();

        // 3. Emit binary frame over WebSockets
        if (ws.readyState === ws.OPEN) {
          ws.send(jpegBuffer, { binary: true });
        }

        // Calculate time taken and regulate framerate (Target ~20-30 FPS depending on network quality)
        const duration = Date.now() - startTime;
        const sleepTime = Math.max(10, 45 - duration); // ~22 FPS cap
        await new Promise((resolve) => setTimeout(resolve, sleepTime));
      } catch (err) {
        console.error(`[STREAM] Error during screen capture step:`, err.message);
        await new Promise((resolve) => setTimeout(resolve, 500)); // Sleep longer on error
      }
    }
  }

  ws.on('close', () => {
    isStreaming = false;
    isAuthenticated = false;
    clearTimeout(authTimeout);
    console.log(`[DISCONN] Client connection closed for: ${clientIp}`);
  });

  ws.on('error', (err) => {
    console.error(`[WS] Client error occurred:`, err.message);
  });
});
