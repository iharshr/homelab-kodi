#!/bin/bash

# Nextcloud Setup Script
# This script sets up the folder structure for Nextcloud document management

set -e

echo "Setting up Nextcloud for document management..."

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo "❌ Docker is not running. Please start Docker first."
    exit 1
fi

# Check if docker-compose.yml exists
if [ ! -f "docker-compose.yml" ]; then
    echo "❌ docker-compose.yml not found. Please run this script from the project directory."
    exit 1
fi

echo "✅ Docker is running"
echo "✅ docker-compose.yml found"

# Create basic folder structure in Documents
echo ""
echo "Creating folder structure in /home/home/Documents..."

# Check if Documents directory exists
if [ ! -d "/home/home/Documents" ]; then
    echo "⚠️  /home/home/Documents directory not found. Creating it..."
    sudo mkdir -p /home/home/Documents
    sudo chown $USER:$USER /home/home/Documents
fi

# Create media folders
mkdir -p /home/home/Documents/Movies
mkdir -p /home/home/Documents/TV-Shows
mkdir -p /home/home/Documents/Music
mkdir -p /home/home/Documents/Pictures
mkdir -p /home/home/Documents/Documents
mkdir -p /home/home/Documents/Downloads

echo "✅ Folder structure created:"
echo "   - /home/home/Documents/Movies"
echo "   - /home/home/Documents/TV-Shows"
echo "   - /home/home/Documents/Music"
echo "   - /home/home/Documents/Pictures"
echo "   - /home/home/Documents/Documents"
echo "   - /home/home/Documents/Downloads"

echo ""
echo "🚀 Nextcloud Setup Complete!"
echo ""
echo "Next steps:"
echo "1. Start Nextcloud: docker compose up -d"
echo "2. Access Nextcloud: http://localhost:9000"
echo "3. Login with: admin / admin123"
echo "4. Navigate to /documents to access your local files"
echo "5. Upload and organize your media files"
echo ""
echo "Your Documents folder is now accessible through Nextcloud for full file management!" 
