#!/bin/bash

echo "Starting virtual display..."
rm -f /tmp/.X99-lock
Xvfb :99 -screen 0 1024x768x16 &
export DISPLAY=:99

cd /root/.minecraft

# Install Fabric CLIENT if not installed
if [ ! -d versions ]; then
  echo "Installing Fabric CLIENT..."
  java -jar /app/fabric-installer.jar client \
    -mcversion 1.21.1 \
    -dir /root/.minecraft \
    -downloadMinecraft
fi

echo "Launching Fabric client..."

FABRIC_JAR=$(find versions -name "fabric-loader-*.jar" | head -n 1)

java -Xmx2G \
  -Dorg.lwjgl.opengl.Display.allowSoftwareOpenGL=true \
  -jar "$FABRIC_JAR"