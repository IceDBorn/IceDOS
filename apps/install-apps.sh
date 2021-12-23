#!/bin/bash

# Install Chaotic AUR as a pacman mirror
echo "Installing Chaotic AUR..."
sudo pacman-key --recv-key FBA220DFC880C036 --keyserver keyserver.ubuntu.com
sudo pacman-key --lsign-key FBA220DFC880C036
sudo pacman -U "https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst" "https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst"
echo "[chaotic-aur]" | sudo tee -a /etc/pacman.conf
echo "Include = /etc/pacman.d/chaotic-mirrorlist" | sudo tee -a /etc/pacman.conf
sudo pacman -Syyu --noconfirm

# Install pacman packages
echo "Installing pacman packages..."
< apps/packages/pacman.txt xargs sudo pacman -S --noconfirm --needed

# Install yay packages
yay -Syyu --noconfirm
echo "Installing yay packages..."
< apps/packages/yay.txt xargs yay -S --noconfirm --needed

# Install Proton GE updater
echo "Installing Proton GE updater..."
sudo pip3 install protonup
mkdir -p ~/.local/share/Steam/compatibilitytools.d/
protonup -d ~/.local/share/Steam/compatibilitytools.d/
protonup -y

# Install RPCS3
echo "Installing RPCS3..."
mkdir -p ~/.local/share/rpcs3/
wget --content-disposition https://rpcs3.net/latest-appimage -O ~/.local/share/rpcs3/rpcs3.AppImage
chmod a+x ~/.local/share/rpcs3/rpcs3.AppImage
cp settings/applications/rpcs3.desktop ~/.local/share/applications/rpcs3.desktop

# Install performance tweaks
echo "Installing performance tweaks..."
git clone https://gitlab.com/garuda-linux/themes-and-settings/settings/performance-tweaks.git
(cd performance-tweaks && makepkg -si)
rm -rf performance-tweaks
