#!/bin/bash

echo "Starting Xvfb..."
Xvfb :99 -screen 0 1024x768x16 &
export DISPLAY=:99

echo "Launching Minecraft..."

java \
  -Xmx2G \
  -Djava.awt.headless=false \
  -jar fabric-loader-0.18.4-1.21.10.jar \
  --username Watchtower1