#!/bin/bash

# Nextcloud Setup Script for Kodi Media Sync
# This script sets up the folder structure and syncs media with Kodi

echo "Setting up Nextcloud with Kodi media sync..."

# Create necessary directories
echo "Creating directories..."
mkdir -p nextcloud/data/admin/files/{Movies,TV-Shows,Pictures,Documents}
mkdir -p media/{movies,tv-shows,pictures,documents}
mkdir -p nextcloud/config
mkdir -p nextcloud/db
mkdir -p nextcloud/apps
mkdir -p nextcloud/themes

# Set proper permissions
echo "Setting permissions..."
sudo chown -R 1000:1000 nextcloud
sudo chown -R 1000:1000 media
sudo chmod -R 755 nextcloud
sudo chmod -R 755 media

# Create symbolic links for media sync
echo "Setting up media sync links..."
ln -sf /media/movies /nextcloud/data/admin/files/Movies
ln -sf /media/tv-shows /nextcloud/data/admin/files/TV-Shows
ln -sf /media/pictures /nextcloud/data/admin/files/Pictures
ln -sf /media/documents /nextcloud/data/admin/files/Documents

echo "Nextcloud setup complete!"
echo ""
echo "Access URLs:"
echo "- Kodi Web Interface: http://localhost"
echo "- Nextcloud: http://localhost/nextcloud"
echo "- Direct Nextcloud: http://localhost:8081"
echo ""
echo "Default credentials:"
echo "- Nextcloud: admin / admin123"
echo "- Samba: kodi / kodi123"
echo ""
echo "Next steps:"
echo "1. Start services: docker-compose up -d"
echo "2. Access Nextcloud and create the folder structure"
echo "3. Configure Kodi to scan the media folders"
echo "4. Upload media files through Nextcloud interface" 
