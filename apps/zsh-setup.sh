#!/bin/bash

# Set zsh as the default shell
echo "Setting zsh as the default shell..."
sudo chsh -s /bin/zsh root
sudo chsh -s /bin/zsh "$username"

# Install zsh theme
echo "Installing zsh theme..."
mkdir -p ~/.config/zsh
cp apps/zsh/zsh-theme.sh ~/.config/zsh/zsh-theme.sh

# Run zsh once to generate default config
echo "Running zsh for the first time..."
zsh

# Install oh my zsh
echo "Installing Oh My Zsh..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install oh my zsh plugins
echo "Installing Oh My Zsh plugins..."
bash ./apps/zsh/install-zsh-plugins.sh

# Append custom config to zsh config file
echo "Adding custom config to '~/.zshrc'..."
cat ~/.zshrc apps/zsh/zsh-config-append-content.txt > ~/.zshrc.new
mv ~/.zshrc ~/.zshrc.old
mv ~/.zshrc.new ~/.zshrc
sed -i 's/^plugins=(\(.*\)/plugins=(archlinux npm nvm sudo systemd zsh-autosuggestions zsh-better-npm-completion zsh-syntax-highlighting \1/' ~/.zshrc

# Revert to zsh config template before adding the firefox profile path
mv apps/zsh/zsh-config-append-content.txt.old zsh/zsh-config-append-content.txt
