#!/bin/bash

# Disaster Recovery Backup Script using Restic and Rclone
# For security reasons, sensitive keys and passwords have been removed.

# Paths to password files (excluded from Git control)
export RESTIC_PASSWORD_FILE="/path/to/restic/password"
RCLONE_CONF="/path/to/rclone/rclone.conf"

# Cloud Repository
REPO="rclone:your_onedrive_remote:ResticBackup"

# Sources to back up
# The script is designed to capture all Docker data and essential config files.
SOURCES="/home/user/docker /home/user/scripts /home/user/.config/rclone /root/.config/restic"

# Log file for monitoring
LOG_FILE="/home/user/scripts/backup.log"

echo "--- Backup Started: $(date) ---" >> $LOG_FILE

# Execute Restic backup command with Rclone backend
restic -o rclone.program="rclone --config $RCLONE_CONF" -r $REPO backup $SOURCES >> $LOG_FILE 2>&1

# Apply retention policy: keep daily 7, weekly 4, monthly 6. Prune old snapshots.
restic -o rclone.program="rclone --config $RCLONE_CONF" -r $REPO forget --prune --keep-daily 7 --keep-weekly 4 --keep-monthly 6 >> $LOG_FILE 2>&1

echo "--- Backup Finished: $(date) ---" >> $LOG_FILE
