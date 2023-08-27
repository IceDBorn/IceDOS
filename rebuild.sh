#!/bin/bash

# cd into script's folder
cd "$(cd "$(dirname "$0")" && pwd)" || exit
pwd > .configuration-location

# Remove previous configuration files
ls -rtd1 /etc/nixos/{*,.*} | grep -v "hardware-configuration.nix" | xargs sudo rm -rf

# Copy configuration files to build folder
sudo cp -r `ls -A | grep -v ".git"` /etc/nixos

# Build the configuration
sudo nixos-rebuild switch --show-trace || exit
