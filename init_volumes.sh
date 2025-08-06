#!/bin/bash
# ===========================================
# Script: init_volumes.sh
# Purpose: Create volume directories for API services
# Usage: ./init_volumes.sh
# ===========================================

VOLUME_BASE="/app/volumes"
SERVICES=("baccarat" "dice" "keno" "roulette" "slots")

echo "🔧 Initializing volume directories..."

# Create base directory if missing
mkdir -p "$VOLUME_BASE"

# Create subfolders for each service
for service in "${SERVICES[@]}"; do
    DIR="$VOLUME_BASE/$service"
    if [ ! -d "$DIR" ]; then
        mkdir -p "$DIR"
        echo "📁 Created: $DIR"
    else
        echo "✅ Exists: $DIR"
    fi
    chmod 777 "$DIR"
done

echo "✅ Volume directories initialized successfully."
