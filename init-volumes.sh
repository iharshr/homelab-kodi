#!/bin/bash

# Initialize Docker Volumes with Configuration Files
# This script sets up the necessary configuration files in Docker volumes

echo "Initializing Docker volumes with configuration files..."

# Create samba config in volume
echo "Setting up Samba configuration..."
docker run --rm -v homelab-kodi_samba_config:/samba_config alpine sh -c "
mkdir -p /samba_config
cat > /samba_config/smb.conf << 'EOF'
[global]
   workgroup = WORKGROUP
   server string = Kodi Media Server
   security = user
   map to guest = bad user
   dns proxy = no
   log level = 1

[media]
   path = /media
   browseable = yes
   writable = yes
   guest ok = yes
   create mask = 0644
   directory mask = 0755
   read list = all
   write list = all

[kodi-config]
   path = /kodi-config
   browseable = yes
   writable = yes
   guest ok = no
   valid users = kodi
   create mask = 0644
   directory mask = 0755

[nextcloud]
   path = /nextcloud-data
   browseable = yes
   writable = no
   guest ok = yes
   read only = yes
EOF
"

# Create media folder structure
echo "Setting up media folder structure..."
docker run --rm -v homelab-kodi_media_storage:/media alpine sh -c "
mkdir -p /media/movies
mkdir -p /media/tv-shows
mkdir -p /media/pictures
mkdir -p /media/documents
mkdir -p /media/music
chmod -R 755 /media
"

# Create SSL directory
echo "Setting up SSL directory..."
docker run --rm -v homelab-kodi_nginx_ssl:/ssl alpine sh -c "
mkdir -p /ssl
chmod 700 /ssl
"

echo "Volume initialization complete!"
echo ""
echo "Next steps:"
echo "1. Start services: docker-compose up -d"
echo "2. Access Kodi: http://localhost"
echo "3. Access Nextcloud: http://localhost/nextcloud"
echo "4. Upload media files through Nextcloud interface"
echo ""
echo "Note: SSL certificates can be added to the nginx_ssl volume for HTTPS support" 
