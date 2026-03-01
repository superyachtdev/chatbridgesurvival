#!/bin/bash

echo "Starting virtual display..."
rm -f /tmp/.X99-lock
Xvfb :99 -screen 0 1024x768x16 &
export DISPLAY=:99

cd /root/.minecraft

# Force install Fabric CLIENT if not present
if [ ! -d "versions/fabric-loader-0.18.4-1.21.1" ]; then
  echo "Installing Fabric CLIENT..."

  java -jar /app/fabric-installer.jar client \
    -mcversion 1.21.1 \
    -loader 0.18.4 \
    -dir /root/.minecraft \
    -downloadMinecraft
fi

echo "Checking for Fabric client jar..."

FABRIC_JAR=$(find versions -type f -name "fabric-loader-*.jar" | head -n 1)

if [ -z "$FABRIC_JAR" ]; then
  echo "❌ Fabric client jar not found!"
  ls -R versions
  exit 1
fi

echo "Launching Fabric client using $FABRIC_JAR"

java -Xmx2G \
  -Dorg.lwjgl.opengl.Display.allowSoftwareOpenGL=true \
  -jar "$FABRIC_JAR"