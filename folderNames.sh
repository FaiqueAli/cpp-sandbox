#!/bin/bash

# git checkout origin/feature/cache

# Define the main branch and the feature branch (current branch)
MAIN_BRANCH="origin/main"
FEATURE_BRANCH="origin/feature/cache"
# FEATURE_BRANCH="origin/$(git rev-parse --abbrev-ref HEAD)"

echo "main branch name: $MAIN_BRANCH"
echo "feature branch name: $FEATURE_BRANCH"

# Folders to check for changes
FOLDERS=("arithmetic_ops" "input_handler" "main_logic")

# Get the list of changed folders
CHANGED_FOLDERS=$(git diff --name-only $MAIN_BRANCH $FEATURE_BRANCH -- "${FOLDERS[@]}" | awk -F'/' '{print $1}' | sort -u)

# Loop through each changed folder and run 'make' if there are changes
for folder in $CHANGED_FOLDERS; do
    echo "Building folder: $folder"
    cd $folder && make && cd ..
done

# Run the master Makefile in the root directory
echo "Running the master Makefile in the root directory."
make
