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
  # PulseAudio
  pulseaudio \
  pulseaudio-utils \
  # Wine
  wine \
  wine32 \
  wine64 \
  # winetricks (for installing fonts inside Wine)
  winetricks \
  # Chromium (for EmulatorJS sessions)
  chromium \
  # Fonts
  fonts-liberation \
  fontconfig \
  # Utilities
  wget \
  curl \
  ca-certificates \
  --no-install-recommends \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# ── Environment ───────────────────────────────────────────────────
ENV DISPLAY=:99
ENV PULSE_SERVER=unix:/tmp/pulse/native
ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
ENV WINEPREFIX=/root/.wine
ENV WINEDEBUG=-all

# ── App ───────────────────────────────────────────────────────────
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .

RUN chmod +x /app/start.sh

EXPOSE 8081
CMD ["/app/start.sh"]
