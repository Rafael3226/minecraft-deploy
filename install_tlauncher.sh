#!/bin/bash

# Exit on error
set -e

echo "Installing TLauncher on Ubuntu 22.04..."

# Update package list
echo "Updating package list..."
sudo apt update

# Install required dependencies
echo "Installing required dependencies..."
sudo apt install -y wget openjdk-17-jre

# Create directory for TLauncher
echo "Creating installation directory..."
mkdir -p ~/.tlauncher

# Download TLauncher
echo "Downloading TLauncher..."
wget -O ~/.tlauncher/TLauncher.jar https://tlauncher.org/jar

# Create desktop entry
echo "Creating desktop entry..."
cat > ~/.local/share/applications/tlauncher.desktop << EOL
[Desktop Entry]
Version=1.0
Type=Application
Name=TLauncher
Comment=Minecraft Launcher
Exec=java -jar ~/.tlauncher/TLauncher.jar
Icon=~/.tlauncher/TLauncher.jar
Terminal=false
Categories=Game;
EOL

# Make the desktop entry executable
chmod +x ~/.local/share/applications/tlauncher.desktop

# Create launcher script
echo "Creating launcher script..."
cat > ~/.local/bin/tlauncher << EOL
#!/bin/bash
java -jar ~/.tlauncher/TLauncher.jar
EOL

# Make the launcher script executable
chmod +x ~/.local/bin/tlauncher

echo "Installation completed successfully!"
echo "You can now launch TLauncher by:"
echo "1. Running 'tlauncher' from the terminal"
echo "2. Finding TLauncher in your applications menu" 