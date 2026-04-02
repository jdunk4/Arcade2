# ── Base ──────────────────────────────────────────────────────────
FROM node:20-bookworm-slim

# ── Enable 32-bit architecture (required by Wine) ─────────────────
RUN dpkg --add-architecture i386

# ── System dependencies ───────────────────────────────────────────
RUN apt-get update && apt-get install -y \
  xvfb \
  x11-utils \
  xdotool \
  ffmpeg \
  pulseaudio \
  pulseaudio-utils \
  wine \
  wine32 \
  wine64 \
  chromium \
  fonts-liberation \
  fontconfig \
  wget \
  curl \
  ca-certificates \
  cabextract \
  unzip \
  --no-install-recommends \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# ── Install winetricks manually from GitHub ───────────────────────
RUN wget -q https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks \
  -O /usr/local/bin/winetricks \
  && chmod +x /usr/local/bin/winetricks

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
