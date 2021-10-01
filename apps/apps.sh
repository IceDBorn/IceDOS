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
"pulseaudio-bluetooth"
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
  echo "${pacman[command]}" | tee -a temp >/dev/null
done
tr '\n' ' ' < temp > temp2
packagesList=$(cat temp2)
eval sudo pacman -S "$packagesList" --noconfirm
rm -rf temp temp2

# Install yay packages
for command in "${!yay[@]}"
do
  echo "${yay[command]}" | tee -a temp >/dev/null
done
tr '\n' ' ' < temp > temp2
packagesList=$(cat temp2)
eval yay -S "$packagesList" --noconfirm
rm -rf temp temp2

# Uninstall packages
for command in "${!uninstall[@]}"
do
  echo "${uninstall[command]}" | tee -a temp >/dev/null
done
tr '\n' ' ' < temp > temp2
packagesList=$(cat temp2)
eval sudo pacman -Rd "$packagesList" --noconfirm
rm -rf temp temp2