#!/bin/bash

# cd into script's folder
cd "$(cd "$(dirname "$0")" && pwd)" || exit
pwd > .configuration-location

# Add configuration files to the appropriate path
sudo cp -r bootloader /etc/nixos
sudo cp -r hardware /etc/nixos
sudo cp -r system /etc/nixos
sudo cp .configuration-location /etc/nixos
sudo cp .nix /etc/nixos
sudo cp configuration.nix /etc/nixos
sudo cp flake.lock /etc/nixos
sudo cp flake.nix /etc/nixos

# Build the configuration
sudo nixos-rebuild switch || exit
