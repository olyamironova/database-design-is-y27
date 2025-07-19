#!/bin/sh
set -e

CRON_SCHEDULE="${BACKUP_INTERVAL_CRON:-0 * * * *}"
echo "[INFO] Starting cron with schedule: $CRON_SCHEDULE..."

touch /var/log/backup.log

echo "$CRON_SCHEDULE /usr/local/bin/pg_backup.sh >> /var/log/backup.log 2>&1" > /etc/crontabs/root

echo "[INFO] Initial run of backup script..."
sh /usr/local/bin/pg_backup.sh >> /var/log/backup.log 2>&1

echo "[INFO] Launching crond..."
crond -f -l 8
