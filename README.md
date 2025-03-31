# Minecraft Server Docker Deployment

This repository contains Docker configuration for running a Minecraft server.

## Prerequisites

- Docker
- Docker Compose

## Quick Start

1. Clone this repository:
```bash
git clone <your-repo-url>
cd minecraft-deploy
```

2. Make the setup script executable and run it:
```bash
chmod +x setup.sh
./setup.sh
```

The setup script will:
- Check for required dependencies
- Create necessary directories
- Configure the server
- Start the Minecraft server
- Configure firewall rules (if UFW is present)

## Manual Setup

If you prefer to set up manually:

1. Start the server:
```bash
docker-compose up -d
```

2. View the logs:
```bash
docker-compose logs -f
```

## Server Management

- Start the server: `docker-compose up -d`
- Stop the server: `docker-compose down`
- Restart the server: `docker-compose restart`
- View logs: `docker-compose logs -f`
- Access server console: `docker-compose exec minecraft sh`

## Server Configuration

The server configuration is stored in `./minecraft_data/server.properties`. You can modify this file to change server settings.

## Data Persistence

All server data is stored in the `./minecraft_data` directory. This includes:
- World data
- Server configuration
- Player data
- Plugins (if added)

## Port

The server runs on port 25565 by default. You can change this in the `docker-compose.yml` file if needed.

## Resource Limits

The server is configured with:
- Minimum RAM: 1GB
- Maximum RAM: 2GB

You can modify these limits in the Dockerfile if needed.

## Troubleshooting

If you encounter any issues:

1. Check the logs:
```bash
docker-compose logs -f
```

2. Verify Docker is running:
```bash
systemctl status docker
```

3. Check container status:
```bash
docker ps
```

4. If needed, you can rebuild the container:
```bash
docker-compose down
docker-compose up -d --build
``` 