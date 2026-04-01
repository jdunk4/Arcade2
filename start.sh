#!/bin/bash
set -e

echo "=== Starting arcade2 server ==="

# Clean up any stale Xvfb lock from previous deploy
rm -f /tmp/.X99-lock /tmp/.X11-unix/X99 2>/dev/null || true

# Start Xvfb virtual display
echo "Starting Xvfb..."
Xvfb :99 -screen 0 1024x768x24 -ac +extension GLX +render -noreset &
XVFB_PID=$!
sleep 2
echo "Xvfb started (pid $XVFB_PID)"

# Start PulseAudio in system mode
echo "Starting PulseAudio..."
mkdir -p /tmp/pulse
pulseaudio --system \
           --disallow-module-loading=false \
           --disallow-exit \
           --daemonize=true || true

# Wait for PulseAudio socket to appear
echo "Waiting for PulseAudio socket..."
for i in $(seq 1 20); do
  if pactl info > /dev/null 2>&1; then
    echo "PulseAudio ready after ${i}s"
    break
  fi
  sleep 1
done

# Load null sink for Chrome audio output
echo "Loading null sink..."
pactl load-module module-null-sink sink_name=virtual_speaker \
  sink_properties=device.description=VirtualSpeaker 2>/dev/null || \
  echo "null sink may already be loaded, continuing..."
pactl set-default-sink virtual_speaker 2>/dev/null || true
echo "PulseAudio virtual_speaker sink ready"

# Start Node server
echo "Starting Node server..."
exec node server-b.js
