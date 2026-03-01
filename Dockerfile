FROM eclipse-temurin:21-jdk

# Install dependencies for headless Minecraft
RUN apt-get update && \
    apt-get install -y xvfb libxext6 libxrender1 libxtst6 libxi6 libgl1-mesa-glx && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy entire repo
COPY . .

# Build the mod inside Docker
RUN ./gradlew build --no-daemon

# Create mods folder
RUN mkdir -p /root/.minecraft/mods

# Copy built jar into Minecraft mods
RUN cp build/libs/*.jar /root/.minecraft/mods/

# Start script
CMD bash run.sh