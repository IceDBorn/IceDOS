#!/bin/bash

username=$(whoami)

# Set zsh as the default shell
echo "Setting zsh as the default shell..."
sudo chsh -s /bin/zsh root
sudo chsh -s /bin/zsh "$username"

# Install zsh theme
echo "Installing zsh theme..."
mkdir -p ~/.config/zsh
cp zsh/theme.sh ~/.config/zsh/theme.sh

# Run zsh once to generate default config
echo "Running zsh for the first time..."
zsh

# Install oh my zsh
echo "Installing Oh My Zsh..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install oh my zsh plugins
echo "Installing Oh My Zsh plugins..."
./zsh/install-plugins.sh

# Append custom config to zsh config file
echo "Adding custom config to '~/.zshrc'..."
cat ~/.zshrc zsh/zsh-custom-config.txt > ~/.zshrc.new
mv ~/.zshrc ~/.zshrc.old
mv ~/.zshrc.new ~/.zshrc
# TODO: Replace default plugins with given list instead of appending the list inside the parenthesis
sed -i 's/^plugins=(\(.*\)/plugins=(archlinux npm nvm sudo systemd zsh-autosuggestions zsh-better-npm-completion zsh-syntax-highlighting \1/' ~/.zshrc

# Revert to zsh config template before adding the firefox profile path
rm zsh/zsh-custom-config.txt
mv zsh/zsh-custom-config.txt.old zsh/zsh-custom-config.txt