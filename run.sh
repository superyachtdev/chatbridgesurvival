#!/bin/bash

echo "Starting virtual display..."
Xvfb :99 -screen 0 1024x768x16 &
export DISPLAY=:99

cd /root/.minecraft

# If fabric loader not installed, install it
if [ ! -f fabric-loader-1.21.1.jar ]; then
  echo "Installing Fabric..."
  java -jar /app/fabric-installer.jar client \
    -mcversion 1.21.1 \
    -dir /root/.minecraft \
    -downloadMinecraft
fi

echo "Launching Fabric..."
java \
  -Xmx2G \
  -Dorg.lwjgl.opengl.Display.allowSoftwareOpenGL=true \
  -jar fabric-loader-*.jar