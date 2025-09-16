#!/bin/bash
# Shell script to create snapshots of Home Assistant configuration files for Copilot reference
# Handles both entity registry and Lovelace configuration
# Run this inside your Home Assistant Docker container

# Configuration files to snapshot
ENTITY_REGISTRY_SOURCE="/config/.storage/core.entity_registry"
ENTITY_REGISTRY_DEST="/config/entity_registry_snapshot.json"

LOVELACE_SOURCE="/config/.storage/lovelace"
LOVELACE_DEST="/config/lovelace_raw_configuration.yaml"

# Exit codes:
# 0 = Success, no changes detected for any file
# 1 = Error occurred
# 2 = Success, changes detected and files updated

CHANGES_MADE=false
ERRORS_OCCURRED=false

# Function to update a snapshot file
update_snapshot() {
    local source_file="$1"
    local dest_file="$2"
    local file_type="$3"
    
    if [ -f "$source_file" ]; then
        # Check if destination file exists and compare with source
        if [ -f "$dest_file" ]; then
            if cmp -s "$source_file" "$dest_file"; then
                echo "$file_type is already up to date - no changes detected"
                return 0
            else
                echo "$file_type changes detected - updating snapshot"
            fi
        else
            echo "Creating initial $file_type snapshot"
        fi
        
        # Copy the file
        cp "$source_file" "$dest_file"
        echo "$file_type copied to $(basename "$dest_file")"
        
        # Set appropriate permissions
        chmod 644 "$dest_file"
        
        # Provide file-specific information
        if command -v jq &> /dev/null; then
            case "$file_type" in
                "Entity registry")
                    ENTITY_COUNT=$(jq '.data.entities | length' "$dest_file" 2>/dev/null || echo "unknown")
                    echo "File contains $ENTITY_COUNT entities"
                    ;;
                "Lovelace configuration")
                    if jq empty "$dest_file" 2>/dev/null; then
                        VIEWS_COUNT=$(jq '.data.config.views | length' "$dest_file" 2>/dev/null || echo "unknown")
                        TITLE=$(jq -r '.data.config.title // "unknown"' "$dest_file" 2>/dev/null || echo "unknown")
                        echo "Configuration contains $VIEWS_COUNT views with title: $TITLE"
                    else
                        echo "Lovelace configuration copied (not standard JSON format)"
                    fi
                    ;;
            esac
        fi
        
        echo "$file_type permissions set to 644"
        CHANGES_MADE=true
        return 2
    else
        echo "Warning: $file_type source file not found: $source_file"
        case "$file_type" in
            "Lovelace configuration")
                echo "This might mean Lovelace is in YAML mode instead of storage mode"
                ;;
        esac
        ERRORS_OCCURRED=true
        return 1
    fi
}

echo "=== Home Assistant Configuration Snapshot Update ==="
echo "Updating snapshots for entity registry and Lovelace configuration..."
echo

# Update Entity Registry
echo "--- Processing Entity Registry ---"
update_snapshot "$ENTITY_REGISTRY_SOURCE" "$ENTITY_REGISTRY_DEST" "Entity registry"
ENTITY_RESULT=$?
echo

# Update Lovelace Configuration
echo "--- Processing Lovelace Configuration ---"
update_snapshot "$LOVELACE_SOURCE" "$LOVELACE_DEST" "Lovelace configuration"
LOVELACE_RESULT=$?
echo

# Summary and exit
echo "=== Summary ==="
if [ "$CHANGES_MADE" = true ]; then
    echo "Configuration snapshots updated successfully"
    if [ "$ERRORS_OCCURRED" = true ]; then
        echo "Note: Some files could not be processed (see warnings above)"
    fi
    echo "Make sure to commit these changes to your repository"
    exit 2
elif [ "$ERRORS_OCCURRED" = true ]; then
    echo "Error: Could not process some configuration files"
    echo "Make sure you're running this inside the Home Assistant container"
    exit 1
else
    echo "All configuration snapshots are already up to date"
    exit 0
fi
