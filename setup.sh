#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}Minecraft Server Docker Setup Script${NC}"
echo "----------------------------------------"

# Function to check if a command exists
check_command() {
    if ! command -v $1 &> /dev/null; then
        echo -e "${YELLOW}$1 is not installed. Installing...${NC}"
        return 1
    fi
    return 0
}

# Install Docker if not present
if check_command docker; then
    echo -e "${GREEN}Docker is already installed${NC}"
else
    echo -e "${YELLOW}Installing Docker...${NC}"
    
    # Remove any old versions
    sudo apt-get remove docker docker-engine docker.io containerd runc
    
    # Install prerequisites
    sudo apt-get update
    sudo apt-get install -y \
        apt-transport-https \
        ca-certificates \
        curl \
        gnupg \
        lsb-release

    # Add Docker's official GPG key
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

    # Set up the stable repository
    echo \
        "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
        $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    # Install Docker Engine
    sudo apt-get update
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io

    # Add current user to docker group
    sudo usermod -aG docker $USER
    echo -e "${YELLOW}Please log out and back in for group changes to take effect${NC}"
fi

# Install Docker Compose if not present
if check_command docker-compose; then
    echo -e "${GREEN}Docker Compose is already installed${NC}"
else
    echo -e "${YELLOW}Installing Docker Compose...${NC}"
    
    # Download Docker Compose
    sudo curl -L "https://github.com/docker/compose/releases/download/v2.24.5/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    
    # Make it executable
    sudo chmod +x /usr/local/bin/docker-compose
fi

# Check Docker service
if ! systemctl is-active --quiet docker; then
    echo -e "${YELLOW}Docker service is not running. Starting Docker...${NC}"
    sudo systemctl start docker
fi

# Create minecraft_data directory if it doesn't exist
if [ ! -d "minecraft_data" ]; then
    echo -e "${YELLOW}Creating minecraft_data directory...${NC}"
    mkdir -p minecraft_data
    chmod 777 minecraft_data
fi

# Check if server.properties exists in minecraft_data
if [ ! -f "minecraft_data/server.properties" ]; then
    echo -e "${YELLOW}Creating default server.properties...${NC}"
    cat > minecraft_data/server.properties << EOL
server-port=25565
gamemode=survival
difficulty=normal
pvp=true
online-mode=false
max-players=20
view-distance=10
spawn-protection=16
motd=Welcome to Minecraft Server!
EOL
fi

# Build and start the container
echo -e "${YELLOW}Building and starting Minecraft server...${NC}"
docker-compose up -d --build

# Check if container is running
if docker ps | grep -q minecraft_server; then
    echo -e "${GREEN}Minecraft server is now running!${NC}"
    echo -e "You can connect to the server at localhost:25565"
    echo -e "\nUseful commands:"
    echo -e "View logs: ${YELLOW}docker-compose logs -f${NC}"
    echo -e "Stop server: ${YELLOW}docker-compose down${NC}"
    echo -e "Restart server: ${YELLOW}docker-compose restart${NC}"
    echo -e "Access console: ${YELLOW}docker-compose exec minecraft sh${NC}"
else
    echo -e "${RED}Failed to start Minecraft server${NC}"
    echo -e "Check the logs with: docker-compose logs"
    exit 1
fi

# Check firewall
if command -v ufw &> /dev/null; then
    if ! ufw status | grep -q "25565/tcp"; then
        echo -e "${YELLOW}Opening port 25565 in firewall...${NC}"
        sudo ufw allow 25565/tcp
    fi
fi

echo -e "\n${GREEN}Setup completed successfully!${NC}"
echo -e "Server configuration can be found in: ${YELLOW}./minecraft_data/server.properties${NC}" 