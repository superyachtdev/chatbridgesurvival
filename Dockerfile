FROM eclipse-temurin:21-jre

RUN apt-get update && \
    apt-get install -y xvfb libxext6 libxrender1 libxtst6 libxi6 libgl1-mesa-glx && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY build/libs/watchtowerbridge-1.0.0.jar /app/mods/
COPY . /app

EXPOSE 25565

CMD ["bash", "run.sh"]