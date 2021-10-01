#!/bin/bash

# Add packages to their corresponding array
pacman=(
"--needed git base-devel yay"
"bluedevil"
"bluez-utils"
"bpytop"
"etcher"
"flameshot"
"gamemode"
"garuda-assistant"
"garuda-boot-options"
"godot-mono"
"gparted"
"gwe"
"jetbrains-toolbox"
"kcalc"
"kdeconnect"
"kitty"
"lib32-mangohud"
"libreoffice-fresh"
"linux-zen"
"linux-zen-headers"
"lutris"
"mangohud"
"mullvad-vpn"
"noto-fonts-emoji"
"npm"
"nvidia-dkms"
"papirus-icon-theme"
"protontricks"
"qbittorrent"
"signal-desktop"
"steam"
"steamtinkerlaunch"
"stremio"
"sublime-text-4"
"tree"
"tutanota-desktop"
"ungoogled-chromium"
"vlc"
"wine"
"winetricks"
"zsh"
)

yay=(
"cadmus-appimage"
"sunshine-git"
)

uninstall=(
"garuda-welcome"
"htop"
"konsole"
"micro"
)

# Install pacman packages
for command in "${!pacman[@]}"
do
  eval sudo pacman -S "${pacman[command]}" --noconfirm
done

# Install yay packages
for command in "${!yay[@]}"
do
  eval yay -S "${yay[command]}" --noconfirm
done

# Uninstall packages
for command in "${!uninstall[@]}"
do
  eval sudo pacman -Rd "${uninstall[command]}" --noconfirm
done