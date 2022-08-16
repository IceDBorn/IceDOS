#!/bin/bash

read -r -p "Install fstab (can break system if it's not configured correctly)? [y/N] " response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]
then
    # Auto mount disks on startup
    echo "Adding mounts to fstab..."
    ( (cat /etc/fstab settings/txt-to-append/fstab.txt > ~/.fstab.txt.new) && (sudo mv /etc/fstab /etc/fstab.old) && (sudo mv ~/.fstab.txt.new /etc/fstab) )

    # Create folders for HDD mounts and change permissions now and on startup
    echo "Creating folders for mounts..."
    ( (sudo mkdir /mnt/Games) && (sudo mkdir /mnt/Storage) && (sudo mkdir /mnt/Windows) )
fi

# Enable nvidia overclocking
(lspci | grep NVIDIA > /dev/null) && ( (echo "Enabling nvidia overclocking...") && (sudo nvidia-xconfig --cool-bits=32) )

# Maximize nvidia GPU power limit on startup
echo "Maximizing Nvidia GPU power limit..."
(lspci | grep NVIDIA > /dev/null) && ( (echo "Maximizing Nvidia GPU power limit...") && (bash ./scripts/add-system-service.sh nv-power-limit) )

# Enable firefox wayland support
echo "Enabling firefox wayland support..."
cp apps/zsh/.zprofile ~/.zprofile

# Add mozilla custom profile
echo "Adding custom mozilla profile..."
randomPath="$HOME/.mozilla/firefox/$RANDOM.privacy"
( (mkdir -p "$randomPath") && (cp settings/firefox/user-overrides.js "$randomPath"/user-overrides.js) && (git clone https://github.com/arkenfox/user.js.git) && (cp user.js/updater.sh "$randomPath"/updater.sh) && (sed -i "s|path-to-mozilla-updater|$randomPath|" ~/.config/zsh/zsh-personal.sh) && (yes | bash "$randomPath"/updater.sh) && (rm -rf user.js) )

# Add nvidia gpu fan control (wayland)
(lspci | grep NVIDIA > /dev/null) && ( (echo "Adding nvidia gpu fan control script for wayland...") && (cp scripts/.nvidia-fan-control-wayland.sh ~/.config/zsh/scripts/.nvidia-fan-control-wayland.sh) )

# Add noise suppression to pipewire
echo "Adding noise suppression to pipewire..."
( (mkdir -p ~/.config/pipewire) && (cp /usr/share/pipewire/pipewire.conf ~/.config/pipewire/pipewire.conf) && (sed -i "/libpipewire-module-session-manager/a $(cat settings/txt-to-append/noise-suppression.txt)" ~/.config/pipewire/pipewire.conf) )

# Add proton remove script to zsh scripts
(cp scripts/.protondown.sh ~/.config/zsh/scripts/.protondown.sh)

# Add post install script to startup
echo "Adding post install script to startup..."
( (mkdir -p ~/.config/autostart) && (cp scripts/.post-install.sh ~/.post-install.sh) && (cp apps/startup/post-install.desktop ~/.config/autostart/post-install.desktop) )
