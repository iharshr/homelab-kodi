#!/bin/bash

# ARM64 Setup Script for Kodi Homelab
# This script handles ARM64-specific setup and troubleshooting

echo "Setting up Kodi Homelab for ARM64 (Apple Silicon)..."

# Check if running on ARM64
ARCH=$(uname -m)
if [ "$ARCH" != "arm64" ] && [ "$ARCH" != "aarch64" ]; then
    echo "Warning: This script is designed for ARM64 systems"
    echo "Detected architecture: $ARCH"
    read -p "Continue anyway? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

# Check Docker platform support
echo "Checking Docker platform support..."
docker version | grep -i "platform" || echo "Docker platform info not available"

# Initialize volumes
echo "Initializing Docker volumes..."
chmod +x init-volumes.sh
./init-volumes.sh

# Check for ARM64 image availability
echo "Checking ARM64 image availability..."

# Test Kodi image
echo "Testing Kodi image..."
if docker pull --platform linux/arm64 linuxserver/kodi-headless:latest; then
    echo "✅ Kodi ARM64 image available"
else
    echo "❌ Kodi ARM64 image not available, trying alternative..."
    # Try alternative Kodi image
    if docker pull --platform linux/arm64 kodi/kodi:latest; then
        echo "✅ Alternative Kodi image available"
        # Update docker-compose to use alternative image
        sed -i '' 's|linuxserver/kodi-headless:latest|kodi/kodi:latest|g' docker-compose.yml
    else
        echo "❌ No ARM64 Kodi image found"
    fi
fi

# Test Nextcloud image
echo "Testing Nextcloud image..."
if docker pull --platform linux/arm64 nextcloud:latest; then
    echo "✅ Nextcloud ARM64 image available"
else
    echo "❌ Nextcloud ARM64 image not available, trying alternative..."
    if docker pull --platform linux/arm64 nextcloud:apache; then
        echo "✅ Nextcloud Apache ARM64 image available"
        sed -i '' 's|nextcloud:latest|nextcloud:apache|g' docker-compose.yml
    else
        echo "❌ No ARM64 Nextcloud image found"
    fi
fi

# Test MariaDB image
echo "Testing MariaDB image..."
if docker pull --platform linux/arm64 mariadb:10.6; then
    echo "✅ MariaDB ARM64 image available"
else
    echo "❌ MariaDB ARM64 image not available, trying alternative..."
    if docker pull --platform linux/arm64 mariadb:latest; then
        echo "✅ MariaDB latest ARM64 image available"
        sed -i '' 's|mariadb:10.6|mariadb:latest|g' docker-compose.yml
    else
        echo "❌ No ARM64 MariaDB image found"
    fi
fi

# Test Samba image
echo "Testing Samba image..."
if docker pull --platform linux/arm64 dperson/samba:latest; then
    echo "✅ Samba ARM64 image available"
else
    echo "❌ Samba ARM64 image not available, trying alternative..."
    if docker pull --platform linux/arm64 alpine/samba:latest; then
        echo "✅ Alternative Samba ARM64 image available"
        sed -i '' 's|dperson/samba:latest|alpine/samba:latest|g' docker-compose.yml
    else
        echo "❌ No ARM64 Samba image found"
    fi
fi

# Test Nginx image
echo "Testing Nginx image..."
if docker pull --platform linux/arm64 nginx:alpine; then
    echo "✅ Nginx ARM64 image available"
else
    echo "❌ Nginx ARM64 image not available"
fi

echo ""
echo "ARM64 setup complete!"
echo ""
echo "If you encounter platform issues, try:"
echo "1. Use the alternative compose file: docker-compose -f docker-compose.arm64.yml up -d"
echo "2. Enable Docker BuildKit: export DOCKER_BUILDKIT=1"
echo "3. Use emulation: docker run --platform linux/amd64 --rm -it alpine:latest"
echo ""
echo "Next steps:"
echo "1. Start services: docker-compose up -d"
echo "2. If issues persist, try: docker-compose -f docker-compose.arm64.yml up -d"
echo "3. Check logs: docker-compose logs"
echo ""
echo "Access URLs:"
echo "- Kodi: http://localhost"
echo "- Nextcloud: http://localhost/nextcloud" 
