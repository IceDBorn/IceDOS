#!/bin/bash

# cd into script's folder
cd "$(cd "$(dirname "$0")" && pwd)" || exit

# Add configuration files to the appropriate path
sudo cp configuration.nix /etc/nixos
sudo cp -r configs /etc/nixos
sudo cp -r scripts /etc/nixos

# Build the configuration
sudo nixos-rebuild switch || exit