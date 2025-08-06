#!/usr/bin/env bash
# ===========================================
# Script: cleanup_old_files.sh
# Purpose: Delete files older than 1 hour in API volumes
# ===========================================

VOLUME_BASE="/app/volumes"
SERVICES=("baccarat" "dice" "keno" "roulette" "slots")
MAX_AGE="+60"   # files older than 60 minutes

echo "🧹 Cleaning old files in $VOLUME_BASE..."

for service in "${SERVICES[@]}"; do
    DIR="$VOLUME_BASE/$service"
    if [ -d "$DIR" ]; then
        echo "🔍 Checking: $DIR"
        find "$DIR" -type f -mmin $MAX_AGE -print -delete
    else
        echo "⚠️ Skipping $DIR (not found)"
    fi
done

echo "✅ Cleanup completed: $(date)"
