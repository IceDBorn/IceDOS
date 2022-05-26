#!/bin/bash

# Enable pacman parallel downloads, add pacman progress bar and add color to output
echo "Customizing pacman..."
sudo sed -i '/^# Misc options/a ParallelDownloads = 16\nILoveCandy\nColor' /etc/pacman.conf

# Update pacman mirrors
echo "Updating pacman mirrors..."
sudo pacman -Syyu --noconfirm

# Install GPU drivers
# You have to install the GPU/Vulkan drivers before installing Steam because Steam defaults to AMD vulkan drivers
(lspci | grep -i '.* vga .* nvidia .*' > /dev/null) && (echo "Installing NVIDIA GPU/Vulkan drivers..." && sudo pacman -S nvidia-open-dkms lib32-nvidia-utils nvidia-utils cuda nvidia-settings --noconfirm)
(lspci | grep -i '.* vga .* amd .*' > /dev/null) && (echo "Installing AMD Vulkan drivers..." && sudo pacman -S lib32-amdvlk --noconfirm)
(lspci | grep -i '.* vga .* intel .*' > /dev/null) && (echo "Installing INTEL Vulkan drivers..." && sudo pacman -S lib32-vulkan-intel --noconfirm)

# Install pacman packages
echo "Installing pacman packages..."
< apps/packages/pacman.txt xargs sudo pacman -S --noconfirm --needed || exit


# Install paru
echo "Installing paru..."
( (git clone https://aur.archlinux.org/paru.git) && (cd paru && makepkg -si) && (rm -rf paru) )

# Update aur mirrors
echo "Updating aur mirrors..."
paru -Syyu --noconfirm --skipreview

# Install nvidia patch only on NVIDIA GPUs
(lspci | grep -i '.* vga .* nvidia .*' > /dev/null) && (echo "Installing NVIDIA driver patch and GreenWithEnvy..." && paru -S nvlax-git gwe --noconfirm --skipreview)

# Install aur packages
echo "Installing aur packages..."
< apps/packages/aur.txt xargs paru -S --needed --skipreview --noconfirm || exit

# Install Proton GE updater
echo "Installing Proton GE updater..."
( (sudo pip3 install protonup-ng) && (mkdir -p ~/.local/share/Steam/compatibilitytools.d/) && (protonup -d ~/.local/share/Steam/compatibilitytools.d/) && (echo "Downloading latest proton ge...") && (yes | protonup) )

# Install RPCS3
echo "Installing RPCS3..."
( (mkdir -p ~/.local/share/rpcs3/) && (wget --content-disposition https://rpcs3.net/latest-appimage -O ~/.local/share/rpcs3/rpcs3.AppImage) && (chmod a+x ~/.local/share/rpcs3/rpcs3.AppImage) && (cp settings/applications/rpcs3.desktop ~/.local/share/applications/rpcs3.desktop) )

# Install performance tweaks
echo "Installing performance tweaks..."
( (git clone https://gitlab.com/garuda-linux/themes-and-settings/settings/performance-tweaks.git) && (cd performance-tweaks && makepkg -si --noconfirm) && (rm -rf performance-tweaks) )
