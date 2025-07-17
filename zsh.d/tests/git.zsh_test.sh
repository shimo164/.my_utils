#!/usr/bin/env bash
set -e  # Exit on any error -->
set -x  # Print each command before executing -->

# 1. Create a temporary test directory
TEST_DIR=$(mktemp -d)
echo "Creating temp directory: $TEST_DIR"
cd "$TEST_DIR"

# 2. Initialize a fresh Git repository
git init

# 3. Test scenario

# Create a file and commit
touch readme.md
git add readme.md
command git commit -m "Initial commit"

# Create files to stash
echo "Hello, world" >> test1.txt
git add test1.txt
git commit -m "Add test1.txt"

echo "Hello, world2" >> test2.txt
git add test2.txt
git commit -m "Add test2.txt"

git log --oneline
# Result will be like this
# 405ca12 (HEAD -> main) Add test2.txt
# cb0b199 Add test1.txt
# a212b1e Initial commit

# Test reset
git reset --soft HEAD~1

# **check this prompt and y + enter
# Are you sure you want to run 'command git reset --soft HEAD~1'? [y/N]:

git status

# Changes to be committed:
#   (use "git restore --staged <file>..." to unstage)
#         new file:   test2.txt

git log --oneline
# cb0b199 (HEAD -> main) Add test1.txt
# a212b1e Initial commit


# Test stash
git stash

**
Stash changes with comment 'On main: 1234abc 01/01 12:00'? [y/N]: y

git stash list
# stash@{0}: On main: On main: cb0b199 03/02 20:00

# Try stash but no changes
git stash
# No changes to stash.

# stash pop and check the output
git stash pop
# Current branch: main
# stash@{0}: On main: On main: cb0b199 03/02 20:00

# Pop stash@{0}: 'On main'. Continue? [y/N]: y

# stash and check the output
git stash -m "with some comment"
# git stash -m "with some comment"
# Stash changes with comment 'On main: 1234abc 01/01 12:00 with some comment'? [y/N]: y

git stash list

# stash apply and check the output
git stash apply

# Clear all stashes
git stash clear
# Current branch: main
# stash@{0}: On main: On main: cb0b199 03/02 20:01 with some comment

# Clear all stashes? This is irreversible. Continue? [y/N]:

# 4. Clean up
# mv to /tmp
cd ..
rm -rf "$TEST_DIR"

# "Test completed successfully."
