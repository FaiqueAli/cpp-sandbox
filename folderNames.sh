#!/bin/bash

# Define the main branch and the feature branch (current branch)
MAIN_BRANCH="origin/main"
FEATURE_BRANCH="origin/$(git rev-parse --abbrev-ref HEAD)"
main_logic_folder="main_logic"
# Folders to check for changes
FOLDERS=("arithmetic_ops" "input_handler")

# Get the list of changed folders
CHANGED_FOLDERS=$(git diff --name-only $MAIN_BRANCH HEAD~1 -- "${FOLDERS[@]}" | awk -F'/' '{print $1}' | sort -u)
# CHANGED_FOLDERS=$(git diff --name-only $MAIN_BRANCH $FEATURE_BRANCH -- "${FOLDERS[@]}" | awk -F'/' '{print $1}' | sort -u)

# Loop through each changed folder and run 'make' if there are changes
ls
for folder in $CHANGED_FOLDERS; do
    echo "Building folder: $folder"
    cd $folder && make && cd ..
done
pwd
ls -ll
cd "$main_logic_folder"
make
chmod 777 "$main_logic_folder"
echo 'the result is ' 
./main_logic

