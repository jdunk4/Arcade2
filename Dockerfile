# ── Base ──────────────────────────────────────────────────────────
FROM node:20-bookworm-slim

# ── Enable 32-bit architecture (required by Wine) ─────────────────
RUN dpkg --add-architecture i386

# ── System dependencies ───────────────────────────────────────────
RUN apt-get update && apt-get install -y \
  # Virtual display
  xvfb \
  x11-utils \
  # Input simulation
  xdotool \
  # Screen/audio capture
  ffmpeg \
  # PulseAudio (for audio routing)
  pulseaudio \
  pulseaudio-utils \
  # Wine
  wine \
  wine32 \
  wine64 \
  # Chromium (for EmulatorJS sessions)
  chromium \
  # Fonts (required by Wine/RPG Maker)
  fonts-liberation \
  ttf-mscorefonts-installer \
  fontconfig \
  # Utilities
  wget \
  curl \
  ca-certificates \
  --no-install-recommends \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# ── Set up virtual display + PulseAudio on startup ────────────────
ENV DISPLAY=:99
ENV PULSE_SERVER=unix:/tmp/pulse/native
ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true

# ── App ───────────────────────────────────────────────────────────
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .

# ── Startup script — boots Xvfb + PulseAudio then starts server ──
COPY start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 8081
CMD ["/start.sh"]
