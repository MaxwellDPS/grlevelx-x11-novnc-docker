#!/bin/bash
export WINEARCH=win32
# Configuration
WINE_PREFIX="${WINEPREFIX:-/wine}"
BACKUP_DIR="${WINEPREFIX:-/config}"
REGISTRY_FILE="$BACKUP_DIR/grlevel2_registry.reg"
GRLEVEL2_PATH="C:\\Program Files\\GRLevelX\\GR2Analyst_3\\gr2analyst.exe"  # Adjust as needed

# Create backup directory if it doesn't exist
mkdir -p "$BACKUP_DIR"

# Function to backup registry
backup_registry() {
    echo "Backing up GRLevel2 registry keys..."
    WINEPREFIX="$WINE_PREFIX" wine regedit /e "$REGISTRY_FILE" "HKEY_CURRENT_USER\\Software\\GRLevel2"
    
    if [ $? -eq 0 ]; then
        echo "Registry backup completed successfully to $REGISTRY_FILE"
        return 0
    else
        echo "Registry backup failed"
        return 1
    fi
}

# Function to restore registry
restore_registry() {
    echo "Restoring GRLevel2 registry keys..."
    
    if [ ! -f "$REGISTRY_FILE" ]; then
        echo "Registry backup file does not exist at $REGISTRY_FILE"
        return 1
    fi
    
    WINEPREFIX="$WINE_PREFIX" wine regedit "$REGISTRY_FILE"
    
    if [ $? -eq 0 ]; then
        echo "Registry restore completed successfully"
        return 0
    else
        echo "Registry restore failed"
        return 1
    fi
}

# Function to start GRLevel2
start_grlevel2() {
    echo "Starting GRLevel2..."
    
    # Ensure DISPLAY is set
    if [ -z "$DISPLAY" ]; then
        export DISPLAY=":0"
    fi
    
    # Run GRLevel2 and capture its exit code
    WINEPREFIX="$WINE_PREFIX" wine "$GRLEVEL2_PATH" "$@"
    return $?
}

# Set up trap to backup registry when script exits
cleanup() {
    echo "Performing cleanup actions..."
    backup_registry
}

# Main execution path for supervisord
main_supervisord() {
    # Restore registry if backup exists
    if [ -f "$REGISTRY_FILE" ]; then
        restore_registry
    else
        echo "No existing registry backup found. Will create one when GRLevel2 exits."
    fi
    
    # Register the cleanup function to run on exit
    trap cleanup EXIT INT TERM
    
    sleep 1

    # Start GRLevel2 and wait for it to complete
    start_grlevel2 "$@"
}

# Command line interface
case "$1" in
    backup)
        backup_registry
        ;;
    restore)
        restore_registry
        ;;
    start)
        start_grlevel2 "${@:2}"
        ;;
    start-with-restore)
        restore_registry && start_grlevel2 "${@:2}"
        ;;
    # Default mode for supervisord
    supervisord|"")
        main_supervisord "${@:2}"
        ;;
    *)
        echo "Usage: $0 {backup|restore|start|start-with-restore|supervisord} [GRLevel2 args...]"
        echo "  backup: Backup GRLevel2 registry keys"
        echo "  restore: Restore GRLevel2 registry keys from backup"
        echo "  start: Start GRLevel2 without restoring registry"
        echo "  start-with-restore: Restore registry then start GRLevel2"
        echo "  supervisord: Run in supervisord mode (default if no arguments)"
        exit 1
        ;;
esac

exit $?