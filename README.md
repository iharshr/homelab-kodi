# Nextcloud Homelab Setup

A complete Docker Compose setup for running Nextcloud with local document management and file sharing capabilities.

## Features

- **Nextcloud**: Cloud storage with organized folders for document management
- **Document Management**: Upload, create, delete, and manage files and folders
- **Local File Access**: Direct access to your local Documents folder
- **Docker Volumes**: Persistent storage using Docker named volumes
- **MariaDB Database**: Reliable database backend for Nextcloud

## Prerequisites

- Docker and Docker Compose installed
- At least 4GB RAM available (Nextcloud requires more memory)
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

4. **Access Nextcloud:**
   - Nextcloud: http://localhost:9000

## Default Credentials

- **Nextcloud**: `admin` / `admin123`

## Docker Volumes

The setup uses Docker named volumes for persistent storage:

### **Volume Structure:**
```
homelab-kodi_nextcloud_data/   # Nextcloud user data
homelab-kodi_nextcloud_config/ # Nextcloud configuration
homelab-kodi_nextcloud_apps/   # Nextcloud apps
homelab-kodi_nextcloud_themes/ # Nextcloud themes
homelab-kodi_nextcloud_db/     # Nextcloud database
```

### **Managing Volumes:**
```bash
# List volumes
docker volume ls | grep homelab-kodi

# Backup a volume
docker run --rm -v homelab-kodi_nextcloud_data:/data -v $(pwd):/backup alpine tar czf /backup/nextcloud_backup.tar.gz -C /data .

# Restore a volume
docker run --rm -v homelab-kodi_nextcloud_data:/data -v $(pwd):/backup alpine tar xzf /backup/nextcloud_backup.tar.gz -C /data

# Remove volumes (WARNING: This will delete all data)
docker compose down -v
```

## Configuration

### Nextcloud Setup

1. **First Access**: Visit http://localhost:9000
2. **Login**: Use `admin` / `admin123`
3. **Create Folders**: The setup creates the basic structure automatically
4. **Upload Media**: Use the web interface to upload files

### Document Management

The setup provides full access to your local Documents folder:

1. **Upload files** to Nextcloud folders
2. **Create new folders** and organize content
3. **Delete files and folders** as needed
4. **Move and rename files** easily
5. **Share files** with other users

### Local Documents Access

Your `/home/home/Documents` folder is mounted and accessible:
- **Full read/write access** through Nextcloud
- **Direct file management** capabilities
- **Organized folder structure** for media and documents

### Adding Media

**Through Nextcloud (Recommended)**
1. Access http://localhost:9000
2. Upload files to appropriate folders
3. Organize your media library

**Direct Volume Access**
```bash
# Copy files directly to the nextcloud data volume
docker run --rm -v homelab-kodi_nextcloud_data:/data -v /path/to/your/files:/files alpine cp -r /files/* /data/admin/files/
```

## Network Access

### Local Network Access

To access from other devices on your network:

1. **Find your server's IP address:**
   ```bash
   ip addr show
   ```

2. **Access from other devices:**
   - Nextcloud: `http://YOUR_SERVER_IP:9000`

### Port Mappings

| Service | Port | Description |
|---------|------|-------------|
| Nextcloud | 9000 | Nextcloud web interface |

## Advanced Configuration

### Custom Nextcloud Configuration

Edit Nextcloud configuration in the volume:
```bash
docker run --rm -it -v homelab-kodi_nextcloud_config:/config alpine sh
# Then edit /config/config.php
```

### Nextcloud Apps

Recommended Nextcloud apps to install:
- **External Storage**: For better file management
- **Media Viewer**: For viewing media files
- **Gallery**: For photo management
- **Documents**: For document editing
- **Calendar**: For scheduling
- **Contacts**: For contact management

## Troubleshooting

### Common Issues

1. **Permission Denied:**
   ```bash
   # Fix volume permissions
   docker run --rm -v homelab-kodi_nextcloud_data:/data alpine chown -R 33:33 /data
   ```

2. **Nextcloud Not Starting:**
   ```bash
   docker compose logs nextcloud
   docker compose logs nextcloud-db
   ```

3. **Database Connection Issues:**
   - Check if MariaDB is running
   - Verify database credentials
   - Restart the database service

4. **Port Already in Use:**
   - Check if other services are using port 9000
   - Modify ports in `docker-compose.yml` if needed

### Logs

View logs for specific services:

```bash
# All services
docker compose logs

# Specific service
docker compose logs nextcloud
docker compose logs nextcloud-db
```

### Backup and Restore

**Backup Nextcloud data:**
```bash
docker compose exec nextcloud-db mysqldump -u nextcloud -p nextcloud > backup_$(date +%Y%m%d_%H%M%S).sql
```

**Backup Nextcloud files:**
```bash
docker run --rm -v homelab-kodi_nextcloud_data:/data -v $(pwd):/backup alpine tar czf /backup/nextcloud_backup_$(date +%Y%m%d_%H%M%S).tar.gz -C /data .
```

**Restore Nextcloud data:**
```bash
# Restore database
docker compose exec -T nextcloud-db mysql -u nextcloud -p nextcloud < backup_YYYYMMDD_HHMMSS.sql

# Restore files
docker run --rm -v homelab-kodi_nextcloud_data:/data -v $(pwd):/backup alpine tar xzf /backup/nextcloud_backup_YYYYMMDD_HHMMSS.tar.gz -C /data
```

## Security Considerations

1. **Change default passwords** in production
2. **Configure firewall** to restrict access
3. **Regular updates** of Docker images
4. **Backup configurations** regularly
5. **Limit Nextcloud access** to trusted networks
6. **Secure volume access** with proper permissions

## Performance Optimization

1. **SSD storage** for Nextcloud data and database
2. **Adequate RAM** (8GB+ recommended for Nextcloud)
3. **Database optimization** for Nextcloud
4. **Volume performance** tuning
5. **Enable Redis** for caching (optional)

## Support

For issues and questions:
- Check Docker logs: `docker compose logs`
- Verify network connectivity
- Ensure proper volume permissions
- Check firewall settings
- Review Nextcloud documentation

## License

This project is open source and available under the MIT License. 
