#!/bin/bash

# cd into script's folder
cd "$(cd "$(dirname "$0")" && pwd)" || exit
printf "$PWD" > .configuration-location

# Copy "/etc/nixos/hardware-configuration.nix" to the project
[ -f "hardware-configuration.nix" ] && rm -f hardware-configuration.nix
cp /etc/nixos/hardware-configuration.nix ./

# Set files to read-only
chmod 444 hardware-configuration.nix
chmod 444 .configuration-location

# Fool flake to use untracked files
# Source: Development tricks - https://nixos.wiki/wiki/Flakes
git add --intent-to-add hardware-configuration.nix
git update-index --skip-worktree hardware-configuration.nix

git add --intent-to-add .configuration-location
git update-index --skip-worktree .configuration-location

# Build the configuration
sudo nixos-rebuild switch --impure --flake .

# Untrack files
git rm --cached --sparse hardware-configuration.nix
git rm --cached --sparse .configuration-location

# Delete files
rm -f hardware-configuration.nix
rm -f .configuration-location
