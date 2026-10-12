#!/bin/bash
# Installiert nach /usr/local/bin/qfc-backup.sh (chmod +x)
set -euo pipefail
BACKUP_ROOT=/mnt/qfc-backup
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
cd /root/qfieldcloud

mkdir -p "$BACKUP_ROOT/postgres"
docker compose exec -T db pg_dump -U qfieldcloud_db_admin -Fc qfieldcloud_db > "$BACKUP_ROOT/postgres/qfieldcloud_db_$TIMESTAMP.dump"
find "$BACKUP_ROOT/postgres" -name "*.dump" -mtime +14 -delete

mkdir -p "$BACKUP_ROOT/rustfs"
docker run --rm -v qfieldcloud_rustfs_data:/data -v "$BACKUP_ROOT/rustfs":/backup alpine \
  tar czf /backup/rustfs_$TIMESTAMP.tar.gz -C /data .
find "$BACKUP_ROOT/rustfs" -name "*.tar.gz" -mtime +7 -delete

mkdir -p "$BACKUP_ROOT/config"
tar czf "$BACKUP_ROOT/config/qfc-config_$TIMESTAMP.tar.gz" \
  .env docker-compose.override.local.yml conf/
find "$BACKUP_ROOT/config" -name "*.tar.gz" -mtime +30 -delete

echo "Backup abgeschlossen: $TIMESTAMP"
