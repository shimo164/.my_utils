#!/bin/bash

# print_out_selected_files.sh
# This script uses fzf to let the user select one or more script files
# from the current directory and its subdirectories, then prints the contents
# of the selected files to the console.

# List of script extensions
exts=("*.sh" "*.py" "*.js" "*.mjs" "*.md" "*.json" "*.html")

# Build the find command to locate scripts of the above types
find_str="find . -type f \( "
for ext in "${exts[@]}"; do
    find_str="${find_str} -name '${ext}' -o"
done
find_str="${find_str::-3} \)" # Remove the last "-o" and close the parentheses

# Execute the find command
scripts=$(eval ${find_str})

# Use fzf to let the user select scripts
selected=$(echo "${scripts}" | fzf -m)

# Print the contents of each selected file
while IFS= read -r line; do
    echo "Here is ${line}"
    echo "------------------------------------"
    cat "${line}"
    echo -e "\n\n"
done <<< "$selected"
