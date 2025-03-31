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

# Install Java if not present
if ! command -v java &> /dev/null; then
    echo -e "${YELLOW}Installing Java...${NC}"
    apt-get update
    apt-get install -y openjdk-17-jre-headless
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
java -Xmx2G -Xms1G -jar minecraft_server.jar nogui
EOL

chmod +x start.sh

echo -e "${GREEN}Installation completed!${NC}"
echo -e "To start the server:"
echo -e "1. cd $MINECRAFT_DIR"
echo -e "2. ./start.sh"
echo -e "\nDefault server port: 25565"
echo -e "You can modify server.properties to change server settings" 