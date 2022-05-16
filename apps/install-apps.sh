#!/bin/bash

# Enable pacman parallel downloads, add pacman progress bar and add color to output
sudo sed -i '/^# Misc options/a ParallelDownloads = 16\nILoveCandy\nColor' /etc/pacman.conf

# Update pacman mirrors
sudo pacman -Syyu --noconfirm

# Install Nvidia drivers
# You have to install the GPU drivers before installing Steam because Steam defaults to AMD vulkan drivers
(lspci | grep NVIDIA > /dev/null) && sudo pacman -S nvidia-open-dkms nvidia-utils lib32-nvidia-utils --noconfirm

# Install pacman packages
echo "Installing pacman packages..."
< apps/packages/pacman.txt xargs sudo pacman -S --noconfirm --needed

# Install paru
(git clone https://aur.archlinux.org/paru.git && cd paru && makepkg -si)

# Install aur packages
paru -Syyu --noconfirm --skipreview

# Install nvidia patch only on NVIDIA GPUs
(lspci | grep NVIDIA > /dev/null) && paru -S nvlax-git --noconfirm --skipreview

echo "Installing aur packages..."
< apps/packages/aur.txt xargs paru -S --needed --skipreview

# Install Proton GE updater
echo "Installing Proton GE updater..."
sudo pip3 install protonup-ng
mkdir -p ~/.local/share/Steam/compatibilitytools.d/
protonup -d ~/.local/share/Steam/compatibilitytools.d/
protonup -y

# Install performance tweaks
echo "Installing performance tweaks..."
git clone https://gitlab.com/garuda-linux/themes-and-settings/settings/performance-tweaks.git
(cd performance-tweaks && makepkg -si --noconfirm)
rm -rf performance-tweaks
