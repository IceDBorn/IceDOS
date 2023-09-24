#!/bin/bash

# cd into script's folder
cd "$(cd "$(dirname "$0")" && pwd)" || exit
printf "$PWD" > .configuration-location

# Copy "/etc/nixos/hardware-configuration.nix" to the project
[ -f "hardware-configuration.nix" ] && rm -f hardware-configuration.nix
cp /etc/nixos/hardware-configuration.nix ./

# Set to read-only as the user should update the original file
chmod 444 hardware-configuration.nix

# Fool flake to use untracked files
# Source: Development tricks - https://nixos.wiki/wiki/Flakes
git add --intent-to-add hardware-configuration.nix
git update-index --skip-worktree hardware-configuration.nix

git add --intent-to-add .configuration-location
git update-index --skip-worktree .configuration-location

# Build the configuration
sudo nixos-rebuild switch --flake .

# Untrack files
git rm --cached --sparse hardware-configuration.nix
git rm --cached --sparse .configuration-location

# Delete the copied hardware-configuration.nix
rm -f hardware-configuration.nix
