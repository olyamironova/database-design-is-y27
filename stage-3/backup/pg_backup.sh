#!/bin/bash
set -e

echo "[INFO] ========== Backup job started: $(date) =========="

BACKUP_DIR="/backups"
mkdir -p "$BACKUP_DIR"

DB_USER="${DB_USER:-migration_admin}"
DB_NAME="${DB_NAME:-db}"
DB_HOST="${DB_HOST:-postgres}"
DB_PORT="${DB_PORT:-5432}"
DB_PASSWORD="${DB_PASSWORD:-migration_admin}"
RETENTION="${BACKUP_RETENTION_COUNT:-5}"

echo "[INFO] DB_HOST: $DB_HOST"
echo "[INFO] DB_PORT: $DB_PORT"
echo "[INFO] DB_USER: $DB_USER"
echo "[INFO] DB_NAME: $DB_NAME"
echo "[INFO] BACKUP_DIR: $BACKUP_DIR"
echo "[INFO] BACKUP_RETENTION_COUNT: $RETENTION"

TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_FILE="$BACKUP_DIR/backup_$TIMESTAMP.sql"

echo "[INFO] Running pg_dump to: $BACKUP_FILE"

if ! PGPASSWORD="$DB_PASSWORD" pg_dump -U "$DB_USER" -h "$DB_HOST" -p "$DB_PORT" "$DB_NAME" > "$BACKUP_FILE"; then
    echo "[ERROR] pg_dump failed at $(date)"
    exit 1
fi

echo "[INFO] Backup successfully created: $BACKUP_FILE"

cd "$BACKUP_DIR" || exit
TOTAL=$(ls backup_*.sql 2>/dev/null | wc -l)

if [ "$TOTAL" -gt "$RETENTION" ]; then
    echo "[INFO] Cleaning old backups..."
    ls -tp backup_*.sql | grep -v '/$' | tail -n +$((RETENTION + 1)) | while read -r file; do
        echo "[INFO] Deleting old backup: $file"
        rm -f "$file"
    done
else
    echo "[INFO] No old backups to delete. Total backups: $TOTAL"
fi

echo "[INFO] ========== Backup job finished: $(date) =========="
