#!/bin/bash

# Set zsh as the default shell
echo "Setting zsh as the default shell..."
( (sudo chsh -s /usr/bin/zsh root) && (sudo chsh -s /usr/bin/zsh "$username") )

# Install zsh theme
echo "Installing zsh theme..."
( (mkdir -p ~/.config/zsh) && (cp apps/zsh/zsh-theme.sh ~/.config/zsh/zsh-theme.sh) )

# Install zsh theme
echo "Installing zsh personal config..."
cp apps/zsh/zsh-personal.sh ~/.config/zsh/zsh-personal.sh

# Create zsh scripts folder
echo "Creating zsh scripts folder..."
mkdir -p ~/.config/zsh/scripts

# Run zsh once to generate default config
echo "Executing zsh for the first time..."
zsh

# Install oh my zsh
echo "Installing Oh My Zsh..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install oh my zsh plugins
echo "Installing Oh My Zsh plugins..."
bash ./apps/zsh/install-zsh-plugins.sh

# Add personal zsh config to zshrc
echo "Adding personal zsh config to '~/.zshrc'..."
( (echo "source ~/.config/zsh/zsh-personal.sh" >> ~/.zshrc) && (sed -i 's/^plugins=(\(.*\)/plugins=(archlinux npm nvm sudo systemd zsh-autosuggestions zsh-better-npm-completion zsh-syntax-highlighting \1/' ~/.zshrc) )
