#!/bin/bash
set -e

echo "=== Starting arcade2 server ==="

# ── Virtual display ────────────────────────────────────────────────────
echo "Starting Xvfb..."
Xvfb :99 -screen 0 1280x720x24 &
export DISPLAY=:99
sleep 1
echo "Xvfb started"

# ── PulseAudio (virtual speaker so emulators have audio output) ────────
echo "Starting PulseAudio as user daemon..."
pulseaudio --start --log-target=stderr --exit-idle-time=-1 2>&1 || true
sleep 1

# Wait for PulseAudio socket
for i in $(seq 1 10); do
    if pactl info > /dev/null 2>&1; then
        echo "PulseAudio socket ready after ${i}s"
        break
    fi
    echo "Waiting for PulseAudio socket..."
    sleep 1
done

export PULSE_SERVER=unix:/tmp/pulse/native

echo "=== PulseAudio sources ==="
pactl list sources short 2>/dev/null || echo "(no sources yet)"
echo "=== PulseAudio ready ==="

# ── Start Node server ──────────────────────────────────────────────────
echo "Starting Node server..."
exec node server-b.js
