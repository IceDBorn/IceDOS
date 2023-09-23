#!/bin/bash

# cd into script's folder
cd "$(cd "$(dirname "$0")" && pwd)" || exit
pwd > .configuration-location

[ -f "hardware-configuration.nix" ] && rm -f hardware-configuration.nix
cp /etc/nixos/hardware-configuration.nix ./
chmod 444 hardware-configuration.nix

git add --intent-to-add hardware-configuration.nix
git update-index --skip-worktree hardware-configuration.nix

# Build the configuration
sudo nixos-rebuild switch --flake .
rm -f hardware-configuration.nix
