#!/bin/bash

# Prompt for MySQL credentials
read -p "MySQL Username: " USER
read -s -p "MySQL Password: " PASS
echo ""

# Set backup base path and create date-time folder
BASE_DIR="/path/to/backup/mysql"
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
BACKUP_DIR="$BASE_DIR/$TIMESTAMP"
mkdir -p "$BACKUP_DIR"

# Get list of non-system databases
databases=$(mysql -u"$USER" -p"$PASS" -e "SHOW DATABASES;" | grep -Ev "Database|information_schema|performance_schema|mysql|sys")

# Dump each database
for db in $databases; do
    echo "Dumping $db..."
    mysqldump -u"$USER" -p"$PASS" --databases "$db" > "$BACKUP_DIR/$db.sql"
done

# Compress the backup folder
echo "Compressing backup..."
tar -czf "$BASE_DIR/mysql_backup_$TIMESTAMP.tar.gz" -C "$BASE_DIR" "$TIMESTAMP"

# Optional: Remove the uncompressed folder after compression
# rm -rf "$BACKUP_DIR"

echo "✅ Backup complete: $BASE_DIR/mysql_backup_$TIMESTAMP.tar.gz"
