#!/bin/bash

# Install zsh theme
echo "Installing zsh theme..."
( (mkdir -p ~/.config/zsh) && (cp apps/zsh/zsh-theme.sh ~/.config/zsh/zsh-theme.sh) )

# Create zsh scripts folder
echo "Creating zsh scripts folder..."
mkdir -p ~/.config/zsh/scripts
