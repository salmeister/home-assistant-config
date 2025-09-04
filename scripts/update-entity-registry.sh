#!/bin/bash
# Shell script to copy entity registry for Copilot reference
# Run this inside your Home Assistant Docker container

# Default paths - adjust if needed
OUTPUT_FILE="${1:-entity_registry_snapshot.json}"

# Use absolute paths to avoid working directory issues
SOURCE_FILE="/config/.storage/core.entity_registry"
DEST_FILE="/config/$OUTPUT_FILE"

# Exit codes:
# 0 = Success, no changes
# 1 = Error occurred
# 2 = Success, changes detected and file updated

if [ -f "$SOURCE_FILE" ]; then
    # Check if destination file exists and compare with source
    if [ -f "$DEST_FILE" ]; then
        if cmp -s "$SOURCE_FILE" "$DEST_FILE"; then
            echo "Entity registry is already up to date - no changes detected"
            exit 0
        else
            echo "Entity registry changes detected - updating snapshot"
        fi
    else
        echo "Creating initial entity registry snapshot"
    fi
    
    # Copy the file
    cp "$SOURCE_FILE" "$DEST_FILE"
    echo "Entity registry copied to $OUTPUT_FILE"
    
    # Count entities using jq if available, otherwise use basic count
    if command -v jq &> /dev/null; then
        ENTITY_COUNT=$(jq '.data.entities | length' "$DEST_FILE" 2>/dev/null || echo "unknown")
        echo "File contains $ENTITY_COUNT entities"
    else
        echo "Entity registry file copied successfully (jq not available for entity count)"
    fi
    
    # Set appropriate permissions
    chmod 644 "$DEST_FILE"
    echo "File permissions set to 644"
    
    # Exit with code 2 to indicate changes were made
    exit 2
else
    echo "Error: Source file not found: $SOURCE_FILE"
    echo "Make sure you're running this inside the Home Assistant container"
    echo "or provide the correct config path as the first argument"
    exit 1
fi
