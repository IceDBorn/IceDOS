#!/bin/bash

# Download the latest proton ge version
yes | protonup

# List all proton ge versions (protonup -l), find the latest version (grep -v), remove it from the list and remove any part not associated with the version tag (grep -o)
binaries=$(protonup -l | grep -v "$(protonup --releases | tail -n 1)" | grep -o '^\S*')

if [ -z "$binaries" ]
then
    echo "No proton GE versions to remove..."
else
        while IFS= read -r line ; do
          # Remove "Proton-" from older versions of proton ge, because the uninstaller fails to match the folders
          line="${line//Proton-/}"
          # Remove all proton ge versions, except the latest one
          yes | protonup -r "$line" && printf "\n"
        done <<< "$binaries"
fi
