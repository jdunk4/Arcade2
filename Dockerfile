FROM ubuntu:22.04

# Prevent interactive prompts during apt installs
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=UTC

# ── System dependencies ────────────────────────────────────────────────
RUN apt-get update && apt-get install -y \
    # Node.js runtime
    curl \
    ca-certificates \
    # Virtual display
    xvfb \
    x11-utils \
    xdotool \
    # Video + audio streaming
    ffmpeg \
    # PulseAudio (virtual speaker for audio capture)
    pulseaudio \
    pulseaudio-utils \
    # SNES emulator
    snes9x-gtk \
    # NES emulator
    fceux \
    # Shared libs often needed by emulators
    libgtk-3-0 \
    libglu1-mesa \
    libgl1-mesa-glx \
    libgl1-mesa-dri \
    libasound2 \
    libpulse0 \
    libsdl2-2.0-0 \
    libsdl2-image-2.0-0 \
    && rm -rf /var/lib/apt/lists/*

# ── Node.js 20 ─────────────────────────────────────────────────────────
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/*

# ── App setup ──────────────────────────────────────────────────────────
WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .

# ── PulseAudio config for headless audio ──────────────────────────────
COPY default.pa /etc/pulse/default.pa

# ── Expose port ────────────────────────────────────────────────────────
EXPOSE 8080

# ── Start script ───────────────────────────────────────────────────────
CMD ["bash", "start.sh"]
