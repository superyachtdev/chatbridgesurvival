FROM eclipse-temurin:21-jdk

RUN apt-get update && \
    apt-get install -y xvfb libxext6 libxrender1 libxtst6 libxi6 libgl1 curl && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY . .

# Install Fabric client
RUN java -jar fabric-installer.jar client -mcversion 1.21.1 -downloadMinecraft

# Build your mod
RUN ./gradlew build --no-daemon

# Copy mod into Minecraft mods folder
RUN mkdir -p /root/.minecraft/mods
RUN cp build/libs/*.jar /root/.minecraft/mods/

CMD bash run.sh