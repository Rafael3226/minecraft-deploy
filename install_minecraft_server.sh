#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}Minecraft Server Installation Script${NC}"
echo "----------------------------------------"

# Check if running as root
if [ "$EUID" -ne 0 ]; then 
    echo -e "${RED}Please run as root (use sudo)${NC}"
    exit 1
fi

# Install Java 21 if not present
if ! command -v java &> /dev/null || ! java -version 2>&1 | grep -q "version \"21"; then
    echo -e "${YELLOW}Installing Java 21...${NC}"
    apt-get update
    apt-get install -y wget apt-transport-https
    mkdir -p /etc/apt/keyrings
    wget -O - https://packages.adoptium.net/artifactory/api/gpg/key/public | tee /etc/apt/keyrings/adoptium.asc
    echo "deb [signed-by=/etc/apt/keyrings/adoptium.asc] https://packages.adoptium.net/artifactory/deb $(awk -F= '/^VERSION_CODENAME/{print$2}' /etc/os-release) main" | tee /etc/apt/sources.list.d/adoptium.list
    apt-get update
    apt-get install -y temurin-21-jre-headless
fi

# Create Minecraft server directory
MINECRAFT_DIR="/opt/minecraft"
if [ ! -d "$MINECRAFT_DIR" ]; then
    mkdir -p "$MINECRAFT_DIR"
    chown -R $SUDO_USER:$SUDO_USER "$MINECRAFT_DIR"
fi

cd "$MINECRAFT_DIR"

# Download Minecraft server
echo -e "${YELLOW}Downloading Minecraft server...${NC}"
wget https://piston-data.mojang.com/v1/objects/e6ec2f64e6080b9b5d9b471b291c33cc7f509733/server.jar -O minecraft_server.jar

# Create eula.txt
echo "eula=true" > eula.txt

# Create server.properties with default settings
cat > server.properties << EOL
server-port=25565
gamemode=survival
difficulty=normal
pvp=true
online-mode=true
max-players=20
view-distance=10
spawn-protection=16
motd=Welcome to Minecraft Server!
EOL

# Create start script
cat > start.sh << EOL
#!/bin/bash
cd $MINECRAFT_DIR
java -Xmx2G -Xms1G -jar minecraft_server.jar nogui
EOL

chmod +x start.sh

# Create systemd service file
echo -e "${YELLOW}Creating systemd service...${NC}"
cat > /etc/systemd/system/minecraft.service << EOL
[Unit]
Description=Minecraft Server
After=network.target

[Service]
WorkingDirectory=$MINECRAFT_DIR
User=$SUDO_USER
Group=$SUDO_USER
Restart=always
ExecStart=$MINECRAFT_DIR/start.sh
RestartSec=3

[Install]
WantedBy=multi-user.target
EOL

# Reload systemd and enable the service
systemctl daemon-reload
systemctl enable minecraft.service

echo -e "${GREEN}Installation completed!${NC}"
echo -e "The Minecraft server will now start automatically on system boot."
echo -e "To manage the server, you can use the following commands:"
echo -e "Start server: sudo systemctl start minecraft"
echo -e "Stop server: sudo systemctl stop minecraft"
echo -e "Check status: sudo systemctl status minecraft"
echo -e "View logs: sudo journalctl -u minecraft"
echo -e "\nDefault server port: 25565"
echo -e "You can modify server.properties to change server settings" 