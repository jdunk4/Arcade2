🕹️ MML Arcade Cabinet

A fully interactive retro arcade cabinet living inside a Metaverse world — built with MML, Node.js, GitHub Pages, and EmulatorJS.

🎮 What Is This? This project brings a playable SNES arcade cabinet into a 3D Metaverse world powered by MML (Metaverse Markup Language). Players can walk up to the cabinet, press E to interact, and launch a real SNES game — all without leaving the world. The cabinet is a fully 3D object with:

A glowing ARCADE marquee A joystick and buttons on the control panel A game screen showing a preview image A proximity interaction prompt A live WebSocket MML document served from Railway

🏗️ Architecture Unreal / MML World ↓ ↓ Railway Node.js WebSocket Server ↓ Serves arcade.html as a live MML document ↓ 3D Arcade Cabinet (m-cube, m-sphere, m-label...) ↓ Player walks up → presses E → game launches ↓ EmulatorJS SNES emulator (hosted on GitHub Pages)

📦 Stack LayerTechnologyMetaverse WorldMML / Unreal EngineMML WebSocket ServerNode.js + Networked DOM (Railway)Static File HostingGitHub PagesSNES EmulatorEmulatorJS (CDN)ROM StorageGitHub Pages /rom/ folderPermanent File BackupArweave

🗂️ Project Structure mml-arcade-server/ ← Railway Node.js server ├── server.js ← WebSocket server entry point ├── arcade.html ← MML arcade cabinet document └── package.json ← Node.js dependencies

jdunk4/Gamer/ ← GitHub Pages site ├── index.html ← MML cabinet (static fallback) ├── game.html ← EmulatorJS emulator page └── rom/ └── yourgame.sfc ← SNES ROM file

🚀 Getting Started

Clone the MML Server Repo bashgit clone https://github.com/jdunk4/mml-arcade-server.git cd mml-arcade-server npm install
Run Locally bashnpm start
Server running on ws://localhost:3000
Deploy to Railway
Push to GitHub Go to railway.app → New Project → Deploy from GitHub Select mml-arcade-server Railway auto-detects Node.js and runs npm start Go to Settings → Networking → Generate Domain Your live WebSocket URL:

wss://mml-arcade-server.railway.app 4. Place in Your MML World html

🎯 How The Emulator Works The emulator is hosted separately on GitHub Pages at: https://jdunk4.github.io/Gamer/game.html It uses EmulatorJS — a browser-based multi-system emulator — to load and run the SNES ROM directly in the browser with zero installation required. Adding Your Own ROM

Add your .sfc ROM file to the rom/ folder in the Gamer GitHub repo Edit game.html and update this line:

javascriptEJS_gameUrl = "./rom/YOUR-ROM-FILENAME.sfc";

Make sure the filename exactly matches (case sensitive!) Commit and push — GitHub Pages auto-deploys within 1-2 minutes

🛠️ MML Cabinet Reference The arcade cabinet is built using these MML elements: ElementPurposeCabinet body, bezel, marquee, control panelJoystick ball and buttonsGlowing ARCADE textGame preview screen image"Press E to Play" proximity promptLaunches the game on interact Customizing the Cabinet Change the cabinet color: html Change the marquee text: html Change interaction range (meters): html Change the game URL: html

🌐 Live URLs ResourceURLMML WebSocket Serverwss://mml-arcade-server.railway.appEmulator Pagehttps://jdunk4.github.io/Gamer/game.htmlMML Cabinet (static)https://jdunk4.github.io/Gamer/

🔧 Troubleshooting Cabinet doesn't appear in world

Check Railway deployment logs — look for MML server running on port... Make sure your m-frame src uses wss:// not https://

Game doesn't load

Check ROM filename is exactly correct including capitalization Verify the file is in the rom/ folder on GitHub Wait 1-2 minutes after pushing — GitHub Pages has a deploy delay

EmulatorJS stuck loading

Check browser console for errors Try a hard refresh (Ctrl + Shift + R) Verify the CDN is reachable: https://cdn.emulatorjs.org/stable/data/loader.js

Wrong base ROM error when patching

Make sure you're using the correct regional version of the game (USA vs EUR vs JPN) Try a different version of the base ROM

📖 Background — How This Was Built This project started as a simple question: "Can we play SNES ROM hacks inside a Metaverse world?" The journey involved:

Converting ROM hack files — learning the difference between .zip, .bps, .sfc, and .gba files and how ROM patching works with Floating IPS Setting up EmulatorJS — hosting a browser-based SNES emulator on GitHub Pages with the ROM file served alongside it Understanding MML — discovering that MML is WebSocket-based and that static hosts like Arweave and GitHub Pages can't serve live MML documents Building the WebSocket server — using @mml-io/networked-dom-server on Railway to serve the arcade cabinet as a proper live MML document Placing it in the world — using to pull the cabinet into the Unreal-based Metaverse world

📚 Resources

MML Documentation EmulatorJS Networked DOM Server ROMhacking.net — ROM hacks and patches Floating IPS (Flips) — BPS/IPS ROM patcher Snes9x — SNES emulator for PC testing Railway — Node.js hosting platform GitHub Pages — Free static file hosting

📄 License MIT — do whatever you want with it. Build cool stuff. 🕹️

Built with ❤️ and a lot of questions about file extensions.
