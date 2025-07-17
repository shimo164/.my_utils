#!/bin/bash

unallowed_branches=("main" "master")

current_branch=$(git branch --show-current)

# Function to check if a value is in the array
contains() {
    local n=$#
    local value=${!n}
    for ((i=1;i < $#;i++)) {
        if [ "${!i}" == "${value}" ]; then
            return 0
        fi
    }
    return 1
}

# Check if current branch is in the unallowed branches
if contains "${unallowed_branches[@]}" "${current_branch}"; then
    echo "You are on the $current_branch branch. Pushing is not allowed!"
else
    # Prompt user for confirmation
    echo "Current branch: $current_branch"
    read -p "git push --set-upstream origin $current_branch: OK? (y/n): " response

    if [[ "$response" =~ ^[Yy]$ ]]; then
        git push --set-upstream origin $current_branch
    else
        echo "Push aborted."
    fi
fi
