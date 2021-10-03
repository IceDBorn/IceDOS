#!/bin/bash

# Add packages to their corresponding array
pacman=(
"--needed git base-devel yay"
"adobe-source-han-sans-cn-fonts"
"adobe-source-han-sans-hk-fonts"
"adobe-source-han-sans-jp-fonts"
"adobe-source-han-sans-kr-fonts"
"adobe-source-han-sans-otc-fonts"
"adobe-source-han-sans-tw-fonts"
"adobe-source-han-serif-cn-fonts"
"adobe-source-han-serif-jp-fonts"
"adobe-source-han-serif-kr-fonts"
"adobe-source-han-serif-otc-fonts"
"adobe-source-han-serif-tw-fonts"
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
"python-pip"
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
"moonlight-qt"
"rar"
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
packagesList=$(cat temp)
sudo pacman -S $packagesList --noconfirm
rm -rf temp

# Install yay packages
for command in "${!yay[@]}"
do
  echo "${yay[command]}" | tee -a temp >/dev/null
done
packagesList=$(cat temp)
yay -S $packagesList --noconfirm
rm -rf temp

# Uninstall packages
for command in "${!uninstall[@]}"
do
  echo "${uninstall[command]}" | tee -a temp >/dev/null
done
packagesList=$(cat temp)
sudo pacman -Rd $packagesList --noconfirm
rm -rf temp temp2
