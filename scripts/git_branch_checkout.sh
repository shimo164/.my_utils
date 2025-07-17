#!/bin/bash

# 1. Read the results of `git branch` and store them in the variable $files
files=$(git branch)

# 2. Add instructions to the list of branches
instructions="
elect a branch from the list below.
You can type to filter the list and press Enter to confirm your selection.
====================
"
branch_list=$(echo -e "$files")

# 3. Reverse the order of branches and instructions using `tac`
reversed_branch_list=$(echo "$branch_list" | tac)

# 4. Use fzf for GUI-like selection of a branch in the terminal
selected_branch=$(echo "$reversed_branch_list" | fzf)

# 5. Check if a branch was selected and perform git checkout
if [ -n "$selected_branch" ]; then
  # Check if the selected item is part of the instructions (by looking for the `===` delimiter)
  if [[ $selected_branch != *"==="* ]]; then
    # Remove the leading '*' and any whitespace from the selected branch name
    branch_name=$(echo "$selected_branch" | sed 's/^\*//; s/^[[:space:]]*//')

    # Perform git checkout on the selected branch
    git checkout "$branch_name"
  else
    echo "Invalid selection. Please try again."
  fi
else
  echo "No branch selected"
fi
