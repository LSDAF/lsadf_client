#!/bin/bash

# Function to convert rarity number to name
get_rarity_name() {
    local rarity_dir="$1"
    echo "$rarity_dir" | tr '[:upper:]' '[:lower:]'
}

# Function to capitalize first letter
capitalize() {
    local word="$1"
    echo "$(tr '[:lower:]' '[:upper:]' <<< ${word:0:1})${word:1}"
}

# Function to extract type from path and ensure correct pluralization
get_type() {
    local path="$1"
    # Get the item type from the path (e.g., boots, weapons, etc.)
    local type=$(echo "$path" | grep -o '/blueprints/[^/]*/' | sed 's|/blueprints/||;s|/||g' | tr '[:upper:]' '[:lower:]')
    
    # Only boots and gloves should be plural, make other types singular
    case "$type" in
        "boots"|"gloves")
            echo "$type"
            ;;
        *)
            # Remove trailing 's' if present
            echo "$type" | sed 's/s$//'
            ;;
    esac
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
    
    # Create new ID (snake_case)
    new_id="${type}_${rarity}_${number}"
    
    # Create new name (Title Case)
    capitalized_type=$(capitalize "$type")
    capitalized_rarity=$(capitalize "$rarity")
    new_name="$capitalized_rarity $capitalized_type $number"
    
    # Update the file
    # First, check if id field exists and update it
    if grep -q '^id = ' "$file"; then
        sed -i '' "s|^id = .*|id = \"$new_id\"|" "$file"
        echo "Updated $file with id: $new_id"
    else
        echo "Warning: Could not find id field in $file"
    fi
    
    # Then check if name field exists and update it
    if grep -q '^name = ' "$file"; then
        sed -i '' "s|^name = .*|name = \"$new_name\"|" "$file"
        echo "Updated $file with name: $new_name"
    else
        echo "Warning: Could not find name field in $file"
    fi
done
