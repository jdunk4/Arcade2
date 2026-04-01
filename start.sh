#!/bin/bash
set -e

echo "=== Starting arcade2 server ==="

# Clean up stale Xvfb lock
rm -f /tmp/.X99-lock /tmp/.X11-unix/X99 2>/dev/null || true

# Start Xvfb
echo "Starting Xvfb..."
Xvfb :99 -screen 0 1024x768x24 -ac +extension GLX +render -noreset &
sleep 2
echo "Xvfb started"

# Start PulseAudio in system mode
echo "Starting PulseAudio..."
mkdir -p /tmp/pulse /run/pulse
pulseaudio --system \
           --disallow-module-loading=false \
           --disallow-exit \
           --daemonize=true || true

# Wait and find the actual socket path
echo "Waiting for PulseAudio socket..."
PULSE_SOCKET=""
for i in $(seq 1 20); do
  # Check both possible socket locations
  if [ -S "/run/pulse/native" ]; then
    PULSE_SOCKET="/run/pulse/native"
    echo "Found PulseAudio socket at /run/pulse/native after ${i}s"
    break
  elif [ -S "/tmp/pulse/native" ]; then
    PULSE_SOCKET="/tmp/pulse/native"
    echo "Found PulseAudio socket at /tmp/pulse/native after ${i}s"
    break
  elif [ -S "/var/run/pulse/native" ]; then
    PULSE_SOCKET="/var/run/pulse/native"
    echo "Found PulseAudio socket at /var/run/pulse/native after ${i}s"
    break
  fi
  echo "  waiting... (${i}s)"
  sleep 1
done

if [ -z "$PULSE_SOCKET" ]; then
  echo "ERROR: PulseAudio socket not found after 20s"
  echo "Searching for any pulse socket..."
  find / -name "native" -path "*/pulse/*" 2>/dev/null || true
  # Try running without audio
  exec node server-b.js
fi

# Export correct socket path
export PULSE_SERVER="unix:${PULSE_SOCKET}"
echo "Using PULSE_SERVER=${PULSE_SERVER}"

# Load null sink
echo "Loading null sink..."
pactl load-module module-null-sink sink_name=virtual_speaker \
  sink_properties=device.description=VirtualSpeaker || \
  echo "null sink may already be loaded"
pactl set-default-sink virtual_speaker || true

# Verify sources
echo "=== PulseAudio sources ==="
pactl list short sources || true
echo "=== PulseAudio ready ==="

exec node server-b.js
