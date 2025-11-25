SOURCE_DIR="$HOME/project_backup/source_file"
BACKUP_DIR="$HOME/project_backup/backup_file"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
DEST_DIR="$BACKUP_DIR/backup_$TIMESTAMP"
LOG_FILE="$BACKUP_DIR/backup.log"
FILE_CRITERIA="*.txt"
DAYS=7

mkdir -p "$DEST_DIR"
mkdir -p "$BACKUP_DIR"

echo "Backup dimulai pada $(date)" >> "$LOG_FILE"

FILE_COUNT=$(find "$SOURCE_DIR" -name "$FILE_CRITERIA" -mtime -$DAYS -exec cp {} "$DEST_DIR" \; -print | wc -l)

if [ $FILE_COUNT -eq 0 ]; then
    echo "Tidak ada file untuk di-backup." >> "$LOG_FILE"
    exit 0
fi

if [ $? -ne 0 ]; then
    echo "Gagal menyalin file." >> "$LOG_FILE"
    echo "Backup gagal."
    exit 1
fi
tar -czf "$BACKUP_DIR/backup_$TIMESTAMP.tar.gz" -C "$DEST_DIR" .

if [ $? -eq 0 ]; then 
    echo "Backup berhasil dikompres menjadi backup_$TIMESTAMP.tar.gz" >> "$LOG_FILE"
    echo "Backup selesai dengan sukses."
    echo "Backup selesai pada $(date)" >> "$LOG_FILE"
else
    echo "Gagal mengompres backup" >> "$LOG_FILE"
    echo "Backup gagal." 
    exit 1
fi

rm -rf "$DEST_DIR"
