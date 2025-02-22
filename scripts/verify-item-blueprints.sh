#!/bin/bash

# Track failures and counters
missing_files=0
id_duplicates=0
name_duplicates=0
sprite_duplicates=0

# Store errors for summary
declare -a error_messages

# Initialize counters
total_files=0
total_ids=0
total_names=0
total_sprites=0

# Arrays to store all IDs, names, and sprite paths for uniqueness check
declare -a all_ids
declare -a all_names
declare -a all_sprites
declare -a sprite_files
declare -a unique_sprite_paths

# Item types
types=("boots" "chestplates" "gloves" "helmets" "shields" "swords")
rarities=('normal' 'common' 'uncommon' 'magic' 'rare' 'legendary' 'unique')

# Arrays to store all IDs, names, and texture rects for uniqueness check
declare -a all_ids
declare -a all_names
declare -a all_rects
declare -a rect_files

echo "Checking all blueprints..."
echo ""

for type in "${types[@]}"; do
    echo "Checking $type..."
    for rarity in "${rarities[@]}"; do
        echo "  $rarity:"
        for num in 1 2; do
            # Keep plural for boots and gloves, singular for others
            if [ "$type" = "boots" ] || [ "$type" = "gloves" ]; then
                singular_type=$type
            else
                singular_type=${type%s}
            fi
            file="src/resources/items/blueprints/$type/$rarity/${rarity}_${singular_type}_${num}.tres"
            total_files=$((total_files + 1))
            echo "    $file:"
            if [ -f "$file" ]; then
                # Get the full file content
                content=$(cat "$file")

                # Extract ID and name from [resource] section
                resource_content=$(echo "$content" | sed -n '/\[resource\]/,/^$/p')
                id=$(echo "$resource_content" | grep 'id = ' | cut -d'"' -f2)
                name=$(echo "$resource_content" | grep 'name = ' | cut -d'"' -f2)

                # Check for Texture2D line and extract path
                if ! echo "$content" | grep -q 'Texture2D.*path='; then
                    error_messages+=("    ❌ No Texture2D found in: $file")
                    ((sprite_duplicates++))
                else
                    sprite_path=$(echo "$content" | grep 'Texture2D.*path=' | grep -o 'path="[^"]*"' | cut -d'"' -f2)

                    # Store values
                    all_ids+=("$id")
                    all_names+=("$name")
                    all_sprites+=("$sprite_path")
                    sprite_files+=("$file")

                    # Check if sprite_path is already in unique_sprite_paths
                    is_unique=1
                    for unique_path in "${unique_sprite_paths[@]}"; do
                        if [ "$unique_path" = "$sprite_path" ]; then
                            is_unique=0
                            break
                        fi
                    done
                    if [ $is_unique -eq 1 ]; then
                        unique_sprite_paths+=("$sprite_path")
                    fi
                fi
            else
                error_messages+=("    ❌ Missing file: $file")
                missing_files=1
            fi
        done
    done
done

echo ""
echo "${total_files} files to be checked."

echo ""
echo "Checking for duplicate IDs..."
for i in "${!all_ids[@]}"; do
    for j in "${!all_ids[@]}"; do
        if [ $i -ne $j ] && [ "${all_ids[i]}" = "${all_ids[j]}" ]; then
            error_messages+=("    ❌ Duplicate ID found: ${all_ids[i]}")
            id_duplicates=1
        fi
    done
done

echo ""
echo "Checking for duplicate names..."

# Debug: Print all names
echo "All names:"
for i in "${!all_names[@]}"; do
    echo "${sprite_files[i]} -> ${all_names[i]}"
done

for i in "${!all_names[@]}"; do
    # Only check against higher indices to avoid showing duplicates twice
    for j in $(seq $((i + 1)) $((${#all_names[@]} - 1))); do
        if [ "${all_names[i]}" = "${all_names[j]}" ]; then
            error_messages+=("    ❌ Duplicate name found in:")
            error_messages+=("      - ${sprite_files[i]} -> ${all_names[i]}")
            error_messages+=("      - ${sprite_files[j]} -> ${all_names[j]}")
            name_duplicates=1
        fi
    done
done

echo ""
echo "Checking for duplicate sprite paths..."
for i in "${!all_sprites[@]}"; do
    # Only check against higher indices to avoid counting duplicates twice
    for j in $(seq $((i + 1)) $((${#all_sprites[@]} - 1))); do
        if [ "${all_sprites[i]}" = "${all_sprites[j]}" ]; then
            error_messages+=("    ❌ Duplicate sprite path found in:")
            error_messages+=("      - ${sprite_files[i]} -> ${all_sprites[i]}")
            error_messages+=("      - ${sprite_files[j]} -> ${all_sprites[j]}")
            ((sprite_duplicates++))
        fi
    done
done

# Print errors if any exist
if [ ${#error_messages[@]} -gt 0 ]; then
    echo "=== Errors ==="
    echo ""
    # Print name duplicates first
    for msg in "${error_messages[@]}"; do
        if [[ $msg == *"Duplicate name found"* ]]; then
            echo "$msg"
        fi
    done
    # Then print other errors
    for msg in "${error_messages[@]}"; do
        if [[ $msg != *"Duplicate name found"* ]]; then
            echo "$msg"
        fi
    done
fi

# Calculate success counts
successful_files=$((total_files - missing_files))

# Print summary
echo ""
echo "=== Summary ==="
echo ""

# File check
if [ $missing_files -eq 0 ]; then
    echo "✅ All required files exist [$total_files/$total_files]"
else
    echo "❌ Found files - [$successful_files/$total_files]"
fi

# Duplicate checks
if [ $id_duplicates -eq 0 ]; then
    echo "✅ No duplicate IDs found [${#all_ids[@]}/${#all_ids[@]}]"
else
    echo "❌ Unique IDs - [$(( ${#all_ids[@]} - id_duplicates ))/${#all_ids[@]}]"
fi

if [ $name_duplicates -eq 0 ]; then
    echo "✅ No duplicate names found [${#all_names[@]}/${#all_names[@]}]"
else
    echo "❌ Unique names - [$(( ${#all_names[@]} - name_duplicates ))/${#all_names[@]}]"
fi

if [ $sprite_duplicates -eq 0 ]; then
    echo "✅ No duplicate sprite paths found [${#all_sprites[@]}/${#all_sprites[@]}]"
else
    echo "❌ Unique sprites - [${#unique_sprite_paths[@]}/${#all_sprites[@]}]"
fi

# Compute final status
if [ $missing_files -gt 0 ] || [ $id_duplicates -gt 0 ] || [ $name_duplicates -gt 0 ] || [ $sprite_duplicates -gt 0 ]; then
    exit 1
else
    exit 0
fi
