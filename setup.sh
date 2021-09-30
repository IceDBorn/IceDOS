#!/bin/bash

# Variables
username=$(whoami)
echo "Hello $username!"

# Make child scripts executable
echo "Marking child scripts as executables..."
sudo chmod +x apps/apps.sh kde-theme/setup.sh photoshop/setup.sh settings/settings.sh single-gpu-passthrough/setup.sh zsh/plugins.sh

# Applications installer
echo "Installing applications..."
./apps/apps.sh

# Settings changer
echo "Changing settings..."
./settings/settings.sh

# Zsh installer
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

# Kitty config installer
echo "Installing kitty config..."
mkdir -p ~/.config/kitty/
cp apps/kitty.conf ~/.config/kitty/kitty.conf

# Flameshot config installer
echo "Installing flameshot config..."
mkdir -p ~/.config/flameshot/
cp apps/flameshot.ini ~/.config/kitty/flameshot.ini

# Pictures mover
echo "Adding pictures to the Pictures directory..."
cp pictures/arcolinux-hello.png ~/Pictures/.arcolinux-hello.png
cp pictures/wallpaper.png ~/Pictures/.wallpaper.png

# Enable ssh
echo "Enabling ssh..."
sudo systemctl enable sshd

# Single gpu passthrough setup
echo "Setting up Single GPU Passthrough..."
./single-gpu-passthrough/setup.sh

# nvm installer
echo "Installing nvm..."
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash

# Theme installer
./kde-theme/setup.sh
sudo mkdir -p /etc/sddm.conf.d/
sudo cp kde-theme/kde_settings.conf /etc/sddm.conf.d/kde_settings.conf

# Photoshop installer
./photoshop/setup.sh

# Rebooting sequence
echo "Rebooting, abort by pressing 'CTRL + C'"
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
