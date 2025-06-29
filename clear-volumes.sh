#!/bin/bash

# Clear Docker Volumes Script for Nextcloud Homelab
# This script helps manage Docker volumes for the Nextcloud setup

set -e

echo "=========================================="
echo "Docker Volume Management for Nextcloud Homelab"
echo "=========================================="

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo "❌ Docker is not running. Please start Docker first."
    exit 1
fi

# List current volumes
echo ""
echo "Current homelab-kodi volumes:"
docker volume ls | grep homelab-kodi || echo "No homelab-kodi volumes found"

# Function to clear a specific volume
clear_volume() {
    local volume_name=$1
    echo "Clearing volume: $volume_name"
    docker volume rm "$volume_name" 2>/dev/null || echo "Volume $volume_name not found or already removed"
}

# Function to clear volumes by type
clear_volume_type() {
    case $1 in
        "nextcloud")
            echo "Clearing Nextcloud volumes..."
            clear_volume "homelab-kodi_nextcloud_data"
            clear_volume "homelab-kodi_nextcloud_config"
            clear_volume "homelab-kodi_nextcloud_apps"
            clear_volume "homelab-kodi_nextcloud_themes"
            clear_volume "homelab-kodi_nextcloud_db"
            ;;
        "all")
            echo "Clearing ALL homelab-kodi volumes..."
            docker volume ls | grep homelab-kodi | awk '{print $2}' | xargs -r docker volume rm
            echo "✅ All homelab-kodi volumes cleared"
            ;;
        *)
            echo "Unknown volume type: $1"
            ;;
    esac
}

# Main menu
while true; do
    echo ""
    echo "Choose an option:"
    echo "1) Clear all volumes (WARNING: This will delete ALL data)"
    echo "2) Clear Nextcloud volumes only (data, config, apps, themes, db)"
    echo "3) Clear specific volume"
    echo "4) List all volumes"
    echo "5) Exit"
    echo ""
    read -p "Enter your choice (1-5): " choice

    case $choice in
        1)
            echo ""
            echo "⚠️  WARNING: This will delete ALL data including:"
            echo "   - Nextcloud user data"
            echo "   - Nextcloud configuration"
            echo "   - Nextcloud apps and themes"
            echo "   - Nextcloud database"
            echo ""
            read -p "Are you sure you want to clear ALL volumes? (yes/no): " confirm
            if [[ $confirm == "yes" ]]; then
                clear_volume_type "all"
            else
                echo "Operation cancelled."
            fi
            ;;
        2)
            echo ""
            echo "⚠️  WARNING: This will delete Nextcloud data including:"
            echo "   - User files and folders"
            echo "   - Nextcloud configuration"
            echo "   - Installed apps and themes"
            echo "   - Database (users, settings, etc.)"
            echo ""
            read -p "Clear Nextcloud volumes? This will delete all Nextcloud data (yes/no): " confirm
            if [[ $confirm == "yes" ]]; then
                clear_volume_type "nextcloud"
                echo "✅ Nextcloud volumes cleared"
            else
                echo "Operation cancelled."
            fi
            ;;
        3)
            echo ""
            echo "Available volumes:"
            docker volume ls | grep homelab-kodi | awk '{print NR") "$2}' || echo "No volumes found"
            echo ""
            read -p "Enter volume number to clear: " vol_num
            if [[ $vol_num =~ ^[0-9]+$ ]]; then
                volume_name=$(docker volume ls | grep homelab-kodi | awk -v num=$vol_num 'NR==num{print $2}')
                if [[ -n $volume_name ]]; then
                    echo ""
                    read -p "Clear volume '$volume_name'? (yes/no): " confirm
                    if [[ $confirm == "yes" ]]; then
                        clear_volume "$volume_name"
                        echo "✅ Volume '$volume_name' cleared"
                    else
                        echo "Operation cancelled."
                    fi
                else
                    echo "❌ Invalid volume number."
                fi
            else
                echo "❌ Please enter a valid number."
            fi
            ;;
        4)
            echo ""
            echo "All homelab-kodi volumes:"
            docker volume ls | grep homelab-kodi || echo "No volumes found"
            ;;
        5)
            echo "Exiting..."
            exit 0
            ;;
        *)
            echo "❌ Invalid choice. Please enter a number between 1-5."
            ;;
    esac
done 
