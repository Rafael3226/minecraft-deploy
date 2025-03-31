FROM eclipse-temurin:21-jre-alpine

# Create minecraft user
RUN addgroup -S minecraft && adduser -S minecraft -G minecraft

# Create server directory
RUN mkdir -p /minecraft && chown -R minecraft:minecraft /minecraft

# Switch to minecraft user
USER minecraft

# Set working directory
WORKDIR /minecraft

# Download server
RUN wget https://piston-data.mojang.com/v1/objects/e6ec2f64e6080b9b5d9b471b291c33cc7f509733/server.jar -O minecraft_server.jar

# Create eula.txt
RUN echo "eula=true" > eula.txt

# Create server.properties with default settings
RUN echo "server-port=25565" > server.properties && \
    echo "gamemode=survival" >> server.properties && \
    echo "difficulty=normal" >> server.properties && \
    echo "pvp=true" >> server.properties && \
    echo "online-mode=true" >> server.properties && \
    echo "max-players=20" >> server.properties && \
    echo "view-distance=10" >> server.properties && \
    echo "spawn-protection=16" >> server.properties && \
    echo "motd=Welcome to Minecraft Server!" >> server.properties

# Expose minecraft server port
EXPOSE 25565

# Start the server
CMD ["java", "-Xmx2G", "-Xms1G", "-jar", "minecraft_server.jar", "nogui"] 