#!/bin/bash

username=$(whoami)

echo "Setting zsh as the default shell..."
sudo chsh -s /bin/zsh root
sudo chsh -s /bin/zsh "$username"

echo "Installing zsh theme..."
cp zsh/promptline.sh ~/.promptline.sh

echo "Running zsh for the first time..."
zsh

echo "Installing Oh My Zsh..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

echo "Installing Oh My Zsh plugins..."
./zsh/plugins.sh

echo "Adding custom config to '~/.zshrc'..."
cat ~/.zshrc zsh/zsh-custom-config.txt > ~/.zshrc.new
mv ~/.zshrc ~/.zshrc.old
mv ~/.zshrc.new ~/.zshrc
sed -i 's/^plugins=(\(.*\)/plugins=(archlinux npm nvm sudo systemd zsh-autosuggestions zsh-better-npm-completion zsh-syntax-highlighting \1/' ~/.zshrc