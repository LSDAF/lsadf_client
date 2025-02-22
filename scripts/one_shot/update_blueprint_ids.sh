#!/bin/bash

# Function to convert rarity number to name
get_rarity_name() {
    local rarity_dir="$1"
    echo "$rarity_dir" | tr '[:upper:]' '[:lower:]'
}

# Function to extract type from path
get_type() {
    local path="$1"
    # Get the item type from the path (e.g., boots, weapons, etc.)
    echo "$path" | grep -o '/blueprints/[^/]*/' | sed 's|/blueprints/||;s|/||g' | tr '[:upper:]' '[:lower:]'
}

# Function to extract number from filename
get_number() {
    local filename="$1"
    echo "$filename" | grep -o '[0-9]*' || echo "1"
}

# Find all .tres files in blueprints directory
find "$(pwd)/src/resources/items/blueprints" -type f -name "*.tres" | while read -r file; do
    # Extract components
    type=$(get_type "$file")
    rarity=$(get_rarity_name "$(basename "$(dirname "$file")")")
    number=$(get_number "$(basename "$file")")
    
    # Create new ID
    new_id="${type}_${rarity}_${number}"
    
    # Update the file
    # First, check if id field exists and is empty or has a different value
    if grep -q '^id = ' "$file"; then
        # Replace existing id line with new id
        sed -i '' "s|^id = .*|id = \"$new_id\"|" "$file"
        echo "Updated $file with id: $new_id"
    else
        echo "Warning: Could not find id field in $file"
    fi
done
