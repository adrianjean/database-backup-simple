#!/bin/bash

# ==== Configuration ====
MYSQL_USER=""     # Set to your MySQL user or leave blank to prompt
MYSQL_PASS=""     # Set to your MySQL password or leave blank to prompt
BACKUP_BASE="/path/to/backup/mysql"
# =======================

# Prompt if user/password not set
if [ -z "$MYSQL_USER" ]; then
    read -p "MySQL Username: " MYSQL_USER
fi

if [ -z "$MYSQL_PASS" ]; then
    read -s -p "MySQL Password: " MYSQL_PASS
    echo ""
fi

# Create timestamped backup directory
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
BACKUP_DIR="$BACKUP_BASE/$TIMESTAMP"
mkdir -p "$BACKUP_DIR"

# Get list of databases (excluding system DBs)
databases=$(mysql -u"$MYSQL_USER" -p"$MYSQL_PASS" -e "SHOW DATABASES;" | grep -Ev "Database|information_schema|performance_schema|mysql|sys")

# Dump each database
for db in $databases; do
    echo "Dumping $db..."
    mysqldump -u"$MYSQL_USER" -p"$MYSQL_PASS" --databases "$db" > "$BACKUP_DIR/$db.sql"
done

# Compress the backup directory
ARCHIVE="$BACKUP_BASE/mysql_backup_$TIMESTAMP.tar.gz"
tar -czf "$ARCHIVE" -C "$BACKUP_BASE" "$TIMESTAMP"

# Optional: Delete uncompressed folder
# rm -rf "$BACKUP_DIR"

echo "✅ Backup complete: $ARCHIVE"
