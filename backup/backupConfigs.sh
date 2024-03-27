#!/bin/bash

# A script to backup configuration files.
# Can be modified to backup files remotely by 
# using scp instead of cp and changing config directory.
# For automation, use cron. 

# Path to backup directory
BACKUP_DIR="$(pwd)/backup"
# Path to config directory
CONFIG_DIR="$(pwd)/configs"
# List of config files to backup
CONFIG_FILES=("file1.conf" "file2.conf")

# To simulate config dir
mkdir -p "$CONFIG_DIR"
echo "file 1 data" > "$CONFIG_DIR/file1.conf" 
echo "file 2 data" > "$CONFIG_DIR/file2.conf"

# Create backup directory if doesn't exist
if [ ! -d "$BACKUP_DIR" ]; then
  mkdir -p "$BACKUP_DIR"
fi

TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

# Backup each file
for file in "${CONFIG_FILES[@]}"; do
    if [ -f "$CONFIG_DIR/$file" ]; then
        cp "$CONFIG_DIR/$file" "$BACKUP_DIR/${file}_$TIMESTAMP"
        echo "Backup of $file completed."
    else
        echo "Error: $file not found. Skipping backup for $file."
    fi
done

echo "Done with backup process!"
