export history_keep_num=1000

# Wrapper function for the 'cd' command
function cd() {
    # If 'cd' command succeeds, add the directory to the history log
    if builtin cd "$@"; then
        cd_history_add_log
    fi
}

# Function to add the current directory to the history log
function cd_history_add_log() {
    # Create a temporary file
    local temp_file=$(mktemp)
    # Escape special characters in the current directory path
    local pwd_escaped=$(printf '%s\n' "$PWD" | sed 's:[\/\.\^\$\*]:\\\\&:g')

    # Read the history log file and add all entries except the current directory to the temporary file
    while IFS= read -r line; do
        if [[ "$line" != "$PWD" ]]; then
            echo "$line" >> "$temp_file"
        fi
    done < ~/.cd_history.log

    # Concatenate the temporary file and the current directory, then overwrite the history log file
    cat "$temp_file" <(echo "$PWD") > ~/.cd_history.log
    # Keep only the last entries of specified number
    tail -n "$history_keep_num" ~/.cd_history.log > "$temp_file" && mv "$temp_file" ~/.cd_history.log
}

# Function to change the directory using the history log and fzf
function cd_history() {
    if [ $# -eq 0 ]; then
        # If no argument is provided, use fzf to select a directory from the history log
        local dir=$(tac ~/.cd_history.log | fzf)
        if [ -n "$dir" ]; then
            # Change to the selected directory using the builtin 'cd' command
            builtin cd "$dir" || return
        fi
    elif [ $# -eq 1 ]; then
        # If one argument is provided, change to that directory using the builtin 'cd' command
        builtin cd "$1" || return
    else
        # If more than one argument is provided, display an error message
        echo "cd_history: too many arguments"
    fi
}

# Define the completion function for cd_history
_cd_history() {
    _files -/
}

# Set up the completion function for cd_history
compdef _cd_history cd_history

# Ensure the history log file exists, create it if necessary
[ -e ~/.cd_history.log ] || touch ~/.cd_history.log
