#!/bin/bash

# Simplified Status Line
# Shows hostname, current directory, and git information

# Read JSON input from stdin
input=$(cat)

# Extract data from JSON input
current_dir=$(echo "$input" | jq -r '.workspace.current_dir')
hostname_short=$(hostname -s)

# ANSI color codes
RESET='\033[0m'
HOSTNAME_COLOR='\033[38;2;255;34;66m'    # burgundy wine red for hostname
FOLDER_COLOR='\033[38;2;5;128;178m'      # Blue for folder
GIT_COLOR='\033[38;2;34;139;34m'         # Green for git
GRAY='\033[90m'                          # Gray for separators

# Icons and separators
HOST_ICON="💻"
FOLDER_ICON="📁"
SEPARATOR="┃"

# Git info
if git rev-parse --git-dir >/dev/null 2>&1; then
    git_branch=$(git branch --show-current 2>/dev/null || git rev-parse --short HEAD 2>/dev/null)
    if [ -n "$git_branch" ]; then
        # Check if there are uncommitted changes
        if ! git diff-index --quiet HEAD -- 2>/dev/null; then
            git_info="🌿 $git_branch ⚡"  # Lightning for uncommitted changes
        else
            git_info="🌿 $git_branch"
        fi
    else
        git_info="🌿 detached"
    fi
else
    git_info=""
fi

# System info
host_component="${HOSTNAME_COLOR}${HOST_ICON} ${hostname_short}${RESET}"
folder_path="${current_dir/#$HOME/~}"
folder_component="${FOLDER_COLOR}${FOLDER_ICON} ${folder_path}${RESET}"

# Assemble the final status line
# Format: Host | Folder | Git
status_line="${host_component} ${GRAY}${SEPARATOR}${RESET} ${folder_component}"

# Add git info if available
if [ -n "$git_info" ]; then
    git_component="${GIT_COLOR}${git_info}${RESET}"
    status_line="${status_line} ${GRAY}${SEPARATOR}${RESET} ${git_component}"
fi

# Output with printf to properly handle ANSI escape sequences
printf "%b" "$status_line"