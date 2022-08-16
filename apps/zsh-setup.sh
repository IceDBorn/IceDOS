#!/bin/bash

# Install zsh theme
echo "Installing zsh theme..."
( (mkdir -p ~/.config/zsh) && (cp apps/zsh/zsh-theme.sh ~/.config/zsh/zsh-theme.sh) )

# Install zsh theme
echo "Installing zsh personal config..."
cp apps/zsh/zsh-personal.sh ~/.config/zsh/zsh-personal.sh

# Create zsh scripts folder
echo "Creating zsh scripts folder..."
mkdir -p ~/.config/zsh/scripts

# Add personal zsh config to zshrc
echo "Adding personal zsh config to '~/.zshrc'..."
(echo "source ~/.config/zsh/zsh-personal.sh" >> ~/.zshrc)
