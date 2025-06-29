# Kodi Homelab Setup with Web Interface, Samba, and Nextcloud

A complete Docker Compose setup for running Kodi with a web interface, Samba file sharing, and Nextcloud for easy local network access and media management.

## Features

- **Kodi Headless**: Runs Kodi without GUI, accessible via web interface
- **Web Interface**: Access Kodi through your browser at `http://localhost:8080`
- **Nextcloud**: Cloud storage with organized folders (Movies, TV-Shows, Pictures, Documents)
- **Samba File Sharing**: Share media files and Kodi configuration across your network
- **Network Discovery**: Kodi can be discovered by other devices on the network
- **Media Sync**: Automatic sync between Nextcloud and Kodi media libraries
- **Docker Volumes**: Persistent storage using Docker named volumes

## Prerequisites

- Docker and Docker Compose installed
- At least 4GB RAM available (Nextcloud requires more memory)
- Network access for media streaming
- At least 10GB free disk space
- Intel x86_64 compatible system

## Quick Start

1. **Clone and navigate to the project:**
   ```bash
   cd homelab-kodi
   ```

2. **Initialize Docker volumes:**
   ```bash
   chmod +x init-volumes.sh
   ./init-volumes.sh
   ```

3. **Start the services:**
   ```bash
   docker compose up -d
   ```

4. **Access the services:**
   - Kodi Web Interface: http://localhost:8080
   - Nextcloud: http://localhost:8081
   - Samba: `\\localhost\media` (Windows) or `smb://localhost/media` (macOS/Linux)

## Default Credentials

- **Nextcloud**: `admin` / `admin123`
- **Samba**: `kodi` / `kodi123`

## Docker Volumes

The setup uses Docker named volumes for persistent storage:

### **Volume Structure:**
```
homelab-kodi_kodi_config/      # Kodi configuration
homelab-kodi_kodi_backup/      # Kodi backups
homelab-kodi_media_storage/    # Media files (movies, TV shows, etc.)
homelab-kodi_nextcloud_data/   # Nextcloud user data
homelab-kodi_nextcloud_config/ # Nextcloud configuration
homelab-kodi_nextcloud_apps/   # Nextcloud apps
homelab-kodi_nextcloud_themes/ # Nextcloud themes
homelab-kodi_nextcloud_db/     # Nextcloud database
homelab-kodi_samba_config/     # Samba configuration
```

### **Managing Volumes:**
```bash
# List volumes
docker volume ls | grep homelab-kodi

# Backup a volume
docker run --rm -v homelab-kodi_media_storage:/data -v $(pwd):/backup alpine tar czf /backup/media_backup.tar.gz -C /data .

# Restore a volume
docker run --rm -v homelab-kodi_media_storage:/data -v $(pwd):/backup alpine tar xzf /backup/media_backup.tar.gz -C /data

# Remove volumes (WARNING: This will delete all data)
docker compose down -v
```

## Configuration

### Nextcloud Setup

1. **First Access**: Visit http://localhost:8081
2. **Login**: Use `admin` / `admin123`
3. **Create Folders**: The setup creates the basic structure automatically
4. **Upload Media**: Use the web interface to upload files

### Media Sync with Kodi

The setup automatically syncs media between Nextcloud and Kodi:

1. **Upload files** to Nextcloud folders
2. **Files are automatically available** in Kodi
3. **Kodi scans** the media folders for new content
4. **Metadata is downloaded** automatically

### Samba Shares

The setup includes three Samba shares:

- **media**: Your media files (movies, TV shows, music)
- **kodi-config**: Kodi configuration files for backup/restore
- **nextcloud**: Nextcloud data files

### Adding Media

**Option 1: Through Nextcloud (Recommended)**
1. Access http://localhost:8081
2. Upload files to appropriate folders
3. Files automatically sync to Kodi

**Option 2: Direct Volume Access**
```bash
# Copy files directly to the media volume
docker run --rm -v homelab-kodi_media_storage:/media -v /path/to/your/movies:/movies alpine cp -r /movies/* /media/movies/
```

## Network Access

### Local Network Access

To access from other devices on your network:

1. **Find your server's IP address:**
   ```bash
   ip addr show
   ```

2. **Access from other devices:**
   - Kodi Web Interface: `http://YOUR_SERVER_IP:8080`
   - Nextcloud: `http://YOUR_SERVER_IP:8081`
   - Samba: `\\YOUR_SERVER_IP\media`

### Port Mappings

| Service | Port | Description |
|---------|------|-------------|
| Kodi | 8080 | Direct Kodi web interface |
| Kodi | 9090 | TCP control |
| Kodi | 9777 | Network discovery (UDP) |
| Nextcloud | 8081 | Direct Nextcloud access |
| Samba | 137-139, 445 | File sharing |

## Advanced Configuration

### Custom Samba Configuration

Edit Samba configuration in the volume:
```bash
docker run --rm -it -v homelab-kodi_samba_config:/samba_config alpine sh
# Then edit /samba_config/smb.conf
```

### Kodi Add-ons and Configuration

1. **Access Kodi web interface**
2. **Install add-ons** (Plex, Netflix, etc.)
3. **Configure media sources** pointing to Samba shares
4. **Set up libraries** for movies, TV shows, and music

### Nextcloud Apps

Recommended Nextcloud apps to install:
- **External Storage**: For better file management
- **Media Viewer**: For viewing media files
- **Gallery**: For photo management
- **Documents**: For document editing

## Troubleshooting

### Common Issues

1. **Permission Denied:**
   ```bash
   # Fix volume permissions
   docker run --rm -v homelab-kodi_media_storage:/media alpine chown -R 1000:1000 /media
   ```

2. **Nextcloud Not Starting:**
   ```bash
   docker compose logs nextcloud
   docker compose logs nextcloud-db
   ```

3. **Media Not Syncing:**
   - Check volume permissions
   - Verify volume mounts are correct
   - Restart Kodi service

4. **Port Already in Use:**
   - Check if other services are using ports 8080, 8081, or 445
   - Modify ports in `docker-compose.yml` if needed

### Logs

View logs for specific services:

```bash
# All services
docker compose logs

# Specific service
docker compose logs kodi
docker compose logs nextcloud
docker compose logs samba
```

### Backup and Restore

**Backup Kodi configuration:**
```bash
docker run --rm -v homelab-kodi_kodi_config:/config -v homelab-kodi_kodi_backup:/backup alpine sh -c "
  cp -r /config /backup/\$(date +%Y%m%d_%H%M%S)
"
```

**Backup Nextcloud data:**
```bash
docker compose exec nextcloud-db mysqldump -u nextcloud -p nextcloud > backup_$(date +%Y%m%d_%H%M%S).sql
```

**Backup media files:**
```bash
docker run --rm -v homelab-kodi_media_storage:/media -v $(pwd):/backup alpine tar czf /backup/media_backup_$(date +%Y%m%d_%H%M%S).tar.gz -C /media .
```

**Restore configurations:**
```bash
# Restore Kodi config
docker run --rm -v homelab-kodi_kodi_config:/config -v homelab-kodi_kodi_backup:/backup alpine sh -c "
  cp -r /backup/BACKUP_DATE/* /config/
"
```

## Security Considerations

1. **Change default passwords** in production
2. **Configure firewall** to restrict access
3. **Regular updates** of Docker images
4. **Backup configurations** regularly
5. **Limit Nextcloud access** to trusted networks
6. **Secure volume access** with proper permissions

## Performance Optimization

1. **Hardware acceleration** (if available):
   ```yaml
   # Add to kodi service in docker-compose.yml
   devices:
     - /dev/dri:/dev/dri
   ```

2. **SSD storage** for media files and databases
3. **Adequate RAM** (8GB+ recommended for Nextcloud)
4. **Network optimization** for streaming
5. **Database optimization** for Nextcloud
6. **Volume performance** tuning

## Support

For issues and questions:
- Check Docker logs: `docker compose logs`
- Verify network connectivity
- Ensure proper volume permissions
- Check firewall settings
- Review Nextcloud and Kodi documentation

## License

This project is open source and available under the MIT License. 
