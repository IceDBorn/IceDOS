#!/bin/bash

# List all proton ge versions (protonup -l), remove every character not associated with the version tag (grep -o '^\S*') and finally remove the latest version from the list (tail -n +2)
binaries=$(tail -n +2 <<< $(protonup -l | grep -o '^\S*'))

if [ -z "$binaries" ]
then
      echo "No proton GE versions to remove..."
else
      # Remove all proton ge versions, except the latest one
	  while IFS= read -r line ; do yes | protonup -r "$line" && printf "\n"; done <<< "$binaries"
fi
