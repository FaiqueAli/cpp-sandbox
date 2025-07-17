#!/bin/bash

# Fetch latest main branch info
git fetch origin main

# Get changed files relative to origin/main
changed_files=$(git diff --name-only origin/main)

if [ -z "$changed_files" ]; then
  echo "No changed files detected compared to origin/main."
  exit 0
fi

# Join changed files by comma for sonar.inclusions
inclusions=$(echo $changed_files | tr ' ' ',')

echo "Changed files:"
echo "$changed_files"
echo
echo "Running SonarScanner on changed files: $inclusions"

# Run sonar-scanner with dynamic sonar.inclusions
sonar-scanner \
  -Dsonar.projectKey=CPP-Sandbox \
  -Dsonar.exclusions=docker-compose/app.py \
  -Dsonar.sources=. \
  -Dsonar.host.url=http://172.26.157.83:9000 \
  -Dsonar.token=sqp_f60657d62d90ee52d93ce8d888e1506c9406f44b \
  -Dsonar.inclusions="$inclusions"
