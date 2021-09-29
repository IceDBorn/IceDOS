#!/bin/bash

# Variables
username=$(whoami)
echo "Hello $username!"

# Make child scripts executable
echo "\nMarking child scripts as executables..."
sudo chmod +x apps/install.sh kde-theme/setup.sh photoshop/setup.sh single-gpu-passthrough/setup.sh zsh/plugins.sh

# Applications installer
echo "\nInstalling applications..."
./apps/install.sh

# Zsh installer
echo "\nSetting zsh as the default shell..."
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

# Kitty config installer
echo "\nInstalling kitty config..."
cp apps/kitty.conf ~/.config/kitty/kitty.conf

# Pictures mover
echo "\nAdding pictures to the Pictures directory..."
cp pictures/arcolinux-hello.png ~/Pictures/.arcolinux-hello.png
cp pictures/wallpaper.png ~/Pictures/.wallpaper.png

# Enable ssh
echo "\nEnabling ssh..."
sudo systemctl enable sshd

# Single gpu passthrough setup
echo "\nSetting up Single GPU Passthrough..."
./single-gpu-passthrough/setup.sh

# nvm installer
echo "\nInstalling nvm..."
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash

# Theme installer
./kde-theme/setup.sh

# Photoshop installer
./photoshop/setup.sh

# Rebooting sequence
echo "\nRebooting, abort by pressing 'CTRL + C'"
for i in {10..1}
do
  if [ "$i" -eq "1" ]; then
    echo -en "\rRebooting in $i second... "
  else
    echo -en "\rRebooting in $i seconds..."
  fi
  sleep 1
done

reboot
