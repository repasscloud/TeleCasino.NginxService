#!/usr/bin/env bash
set -e  # Exit immediately if any command exits with a non-zero status

# ===========================================
# Script: deploy.sh
# Purpose:
#   - Stop existing containers
#   - Pull the latest changes from Git
#   - Initialize required Docker volumes
#   - Rebuild and start Docker containers
#   - Ensure hourly cleanup job exists in crontab
# ===========================================

echo "🔻 Stopping running containers..."
docker compose down

echo "📥 Pulling latest changes from Git repository..."
git pull

echo "📂 Initializing volume directories for API services..."
/app/init_volumes.sh

echo "🚀 Building and starting containers in detached mode..."
docker compose up -d --build

# ✅ Add a cron job for cleaning old files if it doesn't already exist.
# Runs every hour (minute 0) and logs output to /var/log/cleanup_old_files.log
(crontab -l 2>/dev/null | grep -q "cleanup_old_files.sh") || \
  (crontab -l 2>/dev/null; echo "0 * * * * /app/cleanup_old_files.sh >> /var/log/cleanup_old_files.log 2>&1") | crontab -

echo "✅ Deployment completed successfully."
