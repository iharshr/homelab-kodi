# Docker Volume Management Guide

This guide explains how to manage Docker volumes in your Kodi homelab setup.

## Quick Commands

### List All Volumes
```bash
docker volume ls | grep homelab-kodi
```

### Clear All Volumes (WARNING: Deletes ALL data)
```bash
docker-compose down -v
```

### Clear Specific Volume
```bash
docker volume rm homelab-kodi_media_storage
```

### Interactive Volume Management
```bash
chmod +x clear-volumes.sh
./clear-volumes.sh
```

## Volume Types

### Media Volumes
- **`homelab-kodi_media_storage`**: Movies, TV shows, music, pictures, documents
- **Contains**: All your media files

### Nextcloud Volumes
- **`homelab-kodi_nextcloud_data`**: User data, files, settings
- **`homelab-kodi_nextcloud_config`**: Nextcloud configuration
- **`homelab-kodi_nextcloud_apps`**: Installed apps
- **`homelab-kodi_nextcloud_themes`**: Custom themes
- **`homelab-kodi_nextcloud_db`**: MariaDB database

### Kodi Volumes
- **`homelab-kodi_kodi_config`**: Kodi configuration, add-ons, library
- **`homelab-kodi_kodi_backup`**: Kodi backup files

### Configuration Volumes
- **`homelab-kodi_samba_config`**: Samba configuration files
- **`homelab-kodi_nginx_config`**: Nginx main configuration
- **`homelab-kodi_nginx_confd`**: Nginx site configurations
- **`homelab-kodi_nginx_ssl`**: SSL certificates and keys

## Common Operations

### 1. Clear Everything and Start Fresh
```bash
# Stop all services
docker-compose down

# Remove all volumes
docker-compose down -v

# Reinitialize volumes
./init-volumes.sh

# Start services
docker-compose up -d
```

### 2. Clear Only Media Files
```bash
docker volume rm homelab-kodi_media_storage
docker-compose up -d
```

### 3. Clear Only Nextcloud Data
```bash
docker volume rm homelab-kodi_nextcloud_data
docker volume rm homelab-kodi_nextcloud_config
docker volume rm homelab-kodi_nextcloud_apps
docker volume rm homelab-kodi_nextcloud_themes
docker volume rm homelab-kodi_nextcloud_db
docker-compose up -d
```

### 4. Clear Only Kodi Configuration
```bash
docker volume rm homelab-kodi_kodi_config
docker volume rm homelab-kodi_kodi_backup
docker-compose up -d
```

### 5. Backup a Volume
```bash
# Backup media volume
docker run --rm -v homelab-kodi_media_storage:/data -v $(pwd):/backup alpine tar czf /backup/media_backup_$(date +%Y%m%d_%H%M%S).tar.gz -C /data .

# Backup Nextcloud data
docker run --rm -v homelab-kodi_nextcloud_data:/data -v $(pwd):/backup alpine tar czf /backup/nextcloud_backup_$(date +%Y%m%d_%H%M%S).tar.gz -C /data .
```

### 6. Restore a Volume
```bash
# Restore media volume
docker run --rm -v homelab-kodi_media_storage:/data -v $(pwd):/backup alpine tar xzf /backup/media_backup_20241201_120000.tar.gz -C /data

# Restore Nextcloud data
docker run --rm -v homelab-kodi_nextcloud_data:/data -v $(pwd):/backup alpine tar xzf /backup/nextcloud_backup_20241201_120000.tar.gz -C /data
```

## Volume Inspection

### View Volume Contents
```bash
# View media volume contents
docker run --rm -it -v homelab-kodi_media_storage:/media alpine ls -la /media

# View Nextcloud data
docker run --rm -it -v homelab-kodi_nextcloud_data:/data alpine ls -la /data

# View Kodi config
docker run --rm -it -v homelab-kodi_kodi_config:/config alpine ls -la /config
```

### Check Volume Size
```bash
# Check volume sizes
docker system df -v | grep homelab-kodi
```

### View Volume Details
```bash
# Get volume details
docker volume inspect homelab-kodi_media_storage
```

## Troubleshooting

### Volume Permission Issues
```bash
# Fix media volume permissions
docker run --rm -v homelab-kodi_media_storage:/media alpine chown -R 1000:1000 /media

# Fix Nextcloud volume permissions
docker run --rm -v homelab-kodi_nextcloud_data:/data alpine chown -R www-data:www-data /data
```

### Volume Not Found
```bash
# List all volumes
docker volume ls

# Create missing volume
docker volume create homelab-kodi_media_storage
```

### Volume Corruption
```bash
# Remove corrupted volume
docker volume rm homelab-kodi_media_storage

# Recreate volume
docker volume create homelab-kodi_media_storage

# Reinitialize
./init-volumes.sh
```

## Safety Tips

1. **Always backup before clearing volumes**
2. **Use the interactive script for safer operations**
3. **Double-check volume names before deletion**
4. **Keep backups of important data**
5. **Test restore procedures regularly**

## Recovery Procedures

### After Clearing All Volumes
1. Run `./init-volumes.sh` to recreate configuration volumes
2. Start services: `docker-compose up -d`
3. Re-upload media files to Nextcloud
4. Reconfigure Kodi settings

### After Clearing Media Only
1. Restart services: `docker-compose up -d`
2. Re-upload media files to Nextcloud

### After Clearing Nextcloud Only
1. Restart services: `docker-compose up -d`
2. Access Nextcloud and create new admin account
3. Re-upload files

### After Clearing Kodi Only
1. Restart services: `docker-compose up -d`
2. Reconfigure Kodi settings and add-ons
3. Re-scan media libraries 
