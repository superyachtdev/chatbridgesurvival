FROM eclipse-temurin:21-jdk

RUN apt-get update && \
    apt-get install -y xvfb libxext6 libxrender1 libxtst6 libxi6 libgl1 curl && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY . .

RUN ./gradlew build --no-daemon

RUN mkdir -p /root/.minecraft/mods
RUN cp build/libs/*.jar /root/.minecraft/mods/

CMD bash run.sh