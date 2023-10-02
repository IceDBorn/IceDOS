#!/bin/bash

# List of temp files to be added
TEMP_FILES=(
    ".configuration-location"
)

function cleanFiles() {
    [ -f "$0" ] && rm -f $0 && (git rm --cached --sparse $0 > /dev/null)
}

function hideFiles() {
    # Set files to read-only
    chmod 444 $0

    # Fool flake to use untracked files
    # Source: Development tricks - https://nixos.wiki/wiki/Flakes
    git add --intent-to-add $0
    git update-index --skip-worktree $0
}

function removeFiles() {
    # Untrack files
    (git rm --cached --sparse $0 > /dev/null)

    # Delete files
    rm -f $0
}

export -f cleanFiles hideFiles removeFiles

# cd into script's folder
cd "$(cd "$(dirname "$0")" && pwd)" || exit

# Clean temp files
echo "${TEMP_FILES[*]}" | xargs bash -c "cleanFiles"

# Save current directory into a file
printf "$PWD" > .configuration-location

# Partially add temp files to git for flake to work
echo "${TEMP_FILES[*]}" | xargs bash -c "hideFiles"

# Build the configuration
sudo nixos-rebuild switch --impure --flake .

# Remove added temp files after building the configuration
echo "${TEMP_FILES[*]}" | xargs bash -c "removeFiles"
