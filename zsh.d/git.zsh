#!/usr/bin/env bash

display_current_branch_and_stashes() {
    local current_branch=$(git rev-parse --abbrev-ref HEAD)
    echo "Current branch: $current_branch"
    git stash list
    echo
}

get_stash_number_and_message() {
    # $1 could be something like "stash@{n}"
    # If no $1 is provided, default to stash@{0}

    local raw_input="$*"
    local STASH_NUM
    local STASH_MSG

    if [ -z "$raw_input" ]; then
        raw_input="stash@{0}"
    fi

    # Extract stash number from input
    STASH_NUM=$(echo "$raw_input" | sed -n 's/^stash@{*\([0-9]*\)}/\1/p')
    if [ -z "$STASH_NUM" ]; then
        STASH_NUM=0
    fi

    # Grab the stash message
    STASH_MSG=$(git stash list | grep "stash@{${STASH_NUM}}" | awk -F": " '{print $3}')
    echo "$STASH_NUM" "$STASH_MSG"
}

prompt_and_execute_command() {
    # Prompts the user to confirm a command, then executes if 'y'/'Y' is chosen.
    # $1: Prompt message
    # $2: Actual command to execute

    local prompt_message="$1"
    local command_to_execute="$2"

    while true; do
        echo -n "$prompt_message [y/N]: "
        read -r ANS
        case "$ANS" in
            [Yy]* )
                eval "$command_to_execute"
                return 0
                ;;
            [Nn]* | "" )
                echo "Aborted."
                return 1
                ;;
            * )
                # Keep prompting if not recognized
                ;;
        esac
    done
}

# Override the 'git' command (use with caution).
git() {
    if [[ $1 == "stash" && $2 == "pop" ]]; then
        display_current_branch_and_stashes
        read -r STASH_NUM STASH_MSG <<< "$(get_stash_number_and_message "$3")"
        prompt_and_execute_command \
            "Pop stash@{${STASH_NUM}}: '${STASH_MSG}'. Continue?" \
            "command git stash pop stash@{${STASH_NUM}}"

    elif [[ $1 == "stash" && $2 == "apply" ]]; then
        display_current_branch_and_stashes
        read -r STASH_NUM STASH_MSG <<< "$(get_stash_number_and_message "$3")"
        prompt_and_execute_command \
            "Apply stash@{${STASH_NUM}}: '${STASH_MSG}'. Continue?" \
            "command git stash apply stash@{${STASH_NUM}}"

    elif [[ $* == "stash clear" ]]; then
        display_current_branch_and_stashes
        prompt_and_execute_command \
            "Clear all stashes? This is irreversible. Continue?" \
            "command git stash clear"

    # If 'git stash' with no subcommand, then stash with custom comment (branch + commit ID + date)
    elif [[ $1 == "stash" && $2 == "-m" ]]; then
        # Check if there are changes to be stashed
        if git status --porcelain | grep -q '^[ MADRCU]'; then
            shift 2  # Remove the first two arguments
            local user_message="$*"
            local current_branch=$(git rev-parse --abbrev-ref HEAD)
            local short_hash=$(git rev-parse --short HEAD)
            local current_date=$(date +"%m/%d %H:%M")
            local message="On ${current_branch}: ${short_hash} ${current_date} ${user_message}"
            local save_command="git stash save -u \"${message}\""

            prompt_and_execute_command \
                "Stash changes with comment '${message}'?" \
                "$save_command"
        else
            echo "No changes to stash."
            return 1
        fi

    elif [[ $* == "stash" ]]; then
        # Check if there are changes to be stashed
        if git status --porcelain | grep -q '^[ MADRCU]'; then
            local current_branch=$(git rev-parse --abbrev-ref HEAD)
            local short_hash=$(git rev-parse --short HEAD)
            local current_date=$(date +"%m/%d %H:%M")
            local message="On ${current_branch}: ${short_hash} ${current_date}"
            local save_command="git stash save -u \"${message}\""

            prompt_and_execute_command \
                "Stash changes with comment '${message}'?" \
                "$save_command"
        else
            echo "No changes to stash."
            return 1
        fi

    elif [[ $1 == "reset" ]]; then
        # IMPORTANT: Call the real 'git reset' with 'command' so we don't invoke our override again
        local reset_command="command git $*"
        prompt_and_execute_command \
            "Are you sure you want to run '$reset_command'?" \
            "$reset_command"

    else
        # Execute other git commands normally
        command git "$@"
    fi
}
