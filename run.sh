#!/bin/bash

echo "Starting virtual display..."
Xvfb :99 -screen 0 1024x768x16 &
export DISPLAY=:99

echo "Launching Fabric Minecraft..."

cd /root/.minecraft

java \
  -Xmx2G \
  -Dorg.lwjgl.opengl.Display.allowSoftwareOpenGL=true \
  -jar fabric-loader-*.jar