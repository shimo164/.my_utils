#!/bin/bash

# Set the file candidates
zsh_dir=~/.my_utils/zsh.d
file_candidates=("$zsh_dir/zshrc" "$zsh_dir"/*.zsh)

# Use fzf to select multiple files
selected_files=$(printf '%s\n' "${file_candidates[@]}" | fzf --reverse --multi)

# Check if any files were selected
if [ -n "$selected_files" ]; then
    # Save the original IFS and set IFS to newline
    CURRENT_IFS=$IFS
    IFS=$'\n'
    # Read selected files into an array
    files=($selected_files)
    # Restore the original IFS
    IFS=$CURRENT_IFS

    # Open the selected files with code
    for file in "${files[@]}"; do
        code "$file"
    done
else
    echo "No files selected."
fi
