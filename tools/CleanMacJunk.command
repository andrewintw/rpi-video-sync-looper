#!/bin/bash
# Get the directory where the script is located (USB root directory)
DIR="$(cd "$(dirname "$0")"; pwd)"

echo "=== macOS USB Cleanup Tool ==="
echo "Location: $DIR"
echo

# Find all macOS hidden files
JUNK=$(find "$DIR" \( -name "._*" -o -name ".DS_Store" -o -name ".Trashes" -o -name ".Spotlight-V100" -o -name ".fseventsd" \))

if [ -z "$JUNK" ]; then
    echo "No hidden files found. USB is clean!"
else
    echo "Found the following hidden files:"
    echo "$JUNK"
    echo
    read -p "Do you want to delete these files? (y/N) " CONFIRM
    if [[ "$CONFIRM" =~ ^[Yy]$ ]]; then
        find "$DIR" -name "._*" -delete
        rm -rf "$DIR/.DS_Store" "$DIR/.Trashes" "$DIR/.Spotlight-V100" "$DIR/.fseventsd"
        echo "✅ Deleted!"
    else
        echo "❌ Deletion canceled."
    fi
fi

echo
echo "=== Current USB File List ==="
ls -la "$DIR"

echo
read -n 1 -s -r -p "Press any key to close..."
