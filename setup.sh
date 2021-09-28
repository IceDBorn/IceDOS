#!/bin/bash

# Variables
username=$(whoami)
echo "Hello $username!"

# Make child scripts executable
echo "Marking child scripts as executables..."
sudo chmod +x apps/install.sh kde-theme/setup.sh nvm/setup.sh single-gpu-passthrough/setup.sh zsh/plugins.sh

# Applications installer
echo "Installing applications..."
./apps/install.sh

# Zsh installer
echo "Installing zsh plugins..."
./zsh/zsh-plugins.sh

echo "Setting zsh as the default shell..."
sudo chsh -s /bin/zsh root
sudo chsh -s /bin/zsh "$username"

echo "Installing zsh theme..."
cp zsh/promptline.sh ~/.promptline.sh

echo "Running zsh for the first time..."
zsh

echo "Adding custom config to '~/.zshrc'..."
cat ~/.zshrc zsh/zsh-custom-config.txt > ~/.zshrc.new
mv ~/.zshrc ~/.zshrc.old
mv ~/.zshrc.new ~/.zshrc

# Kitty config installer
echo "Installing kitty config..."
cp apps/kitty.conf ~/.config/kitty.conf

# Pictures mover
echo "Adding pictures to the Pictures directory..."
cp pictures/arcolinux-hello.png ~/Pictures/.arcolinux-hello.png
cp pictures/wallpaper.png ~/Pictures/.wallpaper.png

# Enable ssh
echo "Enabling SSH..."
sudo systemctl enable sshd

# Single gpu passthrough setup
echo "Setting up Single GPU Passthrough..."
./single-gpu-passthrough/setup.sh

# NVM installer
.nvm/setup.sh

# Theme installer
.kde-theme/setup.sh

# Rebooting sequence
echo "\nRebooting, abort by pressing 'CTRL + C'"
for i in {5..1}
do
  if [ "$i" -eq "1" ]; then
    echo -en "\rRebooting in $i second... "
  else
    echo -en "\rRebooting in $i seconds..."
  fi
  sleep 1
done

reboot