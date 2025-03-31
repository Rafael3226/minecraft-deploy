# Minecraft Server Installation Script

This script automates the installation and setup of a Minecraft server on Linux systems.

## Prerequisites

- Linux operating system (tested on Ubuntu/Debian)
- Internet connection
- Sudo privileges

## Installation

1. Clone this repository or download the `install_minecraft_server.sh` script
2. Make the script executable:
   ```bash
   chmod +x install_minecraft_server.sh
   ```
3. Run the script with sudo:
   ```bash
   sudo ./install_minecraft_server.sh
   ```

## What the Script Does

- Installs Java 17 if not already installed
- Creates a directory at `/opt/minecraft` for the server
- Downloads the latest Minecraft server JAR file
- Creates necessary configuration files:
  - `eula.txt` (automatically accepts the EULA)
  - `server.properties` with default settings
  - `start.sh` script to run the server

## Starting the Server

1. Navigate to the Minecraft server directory:
   ```bash
   cd /opt/minecraft
   ```
2. Run the start script:
   ```bash
   ./start.sh
   ```

## Server Configuration

You can modify the server settings by editing the `server.properties` file in the Minecraft server directory. Common settings include:

- `server-port`: The port the server runs on (default: 25565)
- `gamemode`: The default game mode (survival, creative, adventure, spectator)
- `difficulty`: The game difficulty (peaceful, easy, normal, hard)
- `max-players`: Maximum number of players allowed
- `motd`: Message of the day (displayed in the server list)

## Notes

- The server requires at least 1GB of RAM to run
- The script allocates 2GB maximum RAM to the server
- Make sure your firewall allows connections on port 25565
- The server runs in survival mode by default
- PvP is enabled by default
- Online mode is enabled (requires valid Minecraft accounts) 