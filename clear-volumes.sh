#!/bin/bash

# Clear Docker Volumes Script for Kodi Homelab
# This script provides options to clear different types of volumes

echo "Docker Volume Management for Kodi Homelab"
echo "=========================================="
echo ""

# Function to list current volumes
list_volumes() {
    echo "Current volumes:"
    docker volume ls | grep homelab-kodi || echo "No homelab-kodi volumes found"
    echo ""
}

# Function to clear specific volume
clear_volume() {
    local volume_name=$1
    echo "Clearing volume: $volume_name"
    docker volume rm $volume_name 2>/dev/null && echo "✅ Cleared $volume_name" || echo "❌ Failed to clear $volume_name"
}

# Function to clear all homelab-kodi volumes
clear_all_volumes() {
    echo "Clearing ALL homelab-kodi volumes..."
    docker volume ls | grep homelab-kodi | awk '{print $2}' | xargs -r docker volume rm
    echo "✅ All homelab-kodi volumes cleared"
}

# Function to clear specific volume types
clear_volume_type() {
    local type=$1
    case $type in
        "media")
            echo "Clearing media volumes..."
            clear_volume "homelab-kodi_media_storage"
            ;;
        "nextcloud")
            echo "Clearing Nextcloud volumes..."
            clear_volume "homelab-kodi_nextcloud_data"
            clear_volume "homelab-kodi_nextcloud_config"
            clear_volume "homelab-kodi_nextcloud_apps"
            clear_volume "homelab-kodi_nextcloud_themes"
            clear_volume "homelab-kodi_nextcloud_db"
            ;;
        "kodi")
            echo "Clearing Kodi volumes..."
            clear_volume "homelab-kodi_kodi_config"
            clear_volume "homelab-kodi_kodi_backup"
            ;;
        "config")
            echo "Clearing configuration volumes..."
            clear_volume "homelab-kodi_samba_config"
            clear_volume "homelab-kodi_nginx_config"
            clear_volume "homelab-kodi_nginx_confd"
            clear_volume "homelab-kodi_nginx_ssl"
            ;;
        *)
            echo "Unknown volume type: $type"
            ;;
    esac
}

# Show current volumes
list_volumes

# Menu options
echo "Choose an option:"
echo "1) Clear ALL volumes (WARNING: This will delete ALL data)"
echo "2) Clear media volumes only (movies, TV shows, etc.)"
echo "3) Clear Nextcloud volumes only (user data, config, database)"
echo "4) Clear Kodi volumes only (config, backups)"
echo "5) Clear configuration volumes only (nginx, samba configs)"
echo "6) Clear specific volume"
echo "7) List volumes only"
echo "8) Exit"
echo ""

read -p "Enter your choice (1-8): " choice

case $choice in
    1)
        echo ""
        read -p "⚠️  WARNING: This will delete ALL data! Are you sure? (yes/no): " confirm
        if [ "$confirm" = "yes" ]; then
            clear_all_volumes
        else
            echo "Operation cancelled"
        fi
        ;;
    2)
        echo ""
        read -p "Clear media volumes? This will delete all movies, TV shows, etc. (yes/no): " confirm
        if [ "$confirm" = "yes" ]; then
            clear_volume_type "media"
        else
            echo "Operation cancelled"
        fi
        ;;
    3)
        echo ""
        read -p "Clear Nextcloud volumes? This will delete all user data and database (yes/no): " confirm
        if [ "$confirm" = "yes" ]; then
            clear_volume_type "nextcloud"
        else
            echo "Operation cancelled"
        fi
        ;;
    4)
        echo ""
        read -p "Clear Kodi volumes? This will delete Kodi configuration and backups (yes/no): " confirm
        if [ "$confirm" = "yes" ]; then
            clear_volume_type "kodi"
        else
            echo "Operation cancelled"
        fi
        ;;
    5)
        echo ""
        read -p "Clear configuration volumes? This will delete nginx and samba configs (yes/no): " confirm
        if [ "$confirm" = "yes" ]; then
            clear_volume_type "config"
        else
            echo "Operation cancelled"
        fi
        ;;
    6)
        echo ""
        echo "Available volumes:"
        docker volume ls | grep homelab-kodi | awk '{print NR") "$2}' || echo "No volumes found"
        echo ""
        read -p "Enter volume number to clear: " vol_num
        volume_name=$(docker volume ls | grep homelab-kodi | awk -v num=$vol_num 'NR==num{print $2}')
        if [ -n "$volume_name" ]; then
            read -p "Clear volume '$volume_name'? (yes/no): " confirm
            if [ "$confirm" = "yes" ]; then
                clear_volume "$volume_name"
            else
                echo "Operation cancelled"
            fi
        else
            echo "Invalid volume number"
        fi
        ;;
    7)
        list_volumes
        ;;
    8)
        echo "Exiting..."
        exit 0
        ;;
    *)
        echo "Invalid choice"
        exit 1
        ;;
esac

echo ""
echo "Current volumes after operation:"
list_volumes

echo "Note: After clearing volumes, you may need to:"
echo "1. Re-run init-volumes.sh to recreate configuration volumes"
echo "2. Restart services: docker-compose up -d"
echo "3. Re-upload media files to Nextcloud" 
