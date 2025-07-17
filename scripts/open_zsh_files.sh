#!/bin/bash

# Set the file candidates
file_candidates=(~/.zshrc ~/.my_utils/zsh.d/*.zsh)

# Use fzf to select multiple files
selected_files=$(printf '%s\n' "${file_candidates[@]}" | fzf --reverse --multi)

# Check if any files were selected
if [ -n "$selected_files" ]; then
    # Save the original IFS and set IFS to newline
    OLDIFS=$IFS
    IFS=$'\n'
    # Read selected files into an array
    files=($selected_files)
    # Restore the original IFS
    IFS=$OLDIFS

    # Open the selected files with code
    for file in "${files[@]}"; do
        code "$file"
    done
else
    echo "No files selected."
fi
