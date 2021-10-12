#!/bin/bash

echo "Installing applications..."

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
"duckstation-git"
"etcher"
"firefox-nightly"
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
"nvtop"
"papirus-icon-theme"
"paru"
"pcsx2"
"powerpill"
"ppsspp"
"protontricks"
"pulseaudio-bluetooth"
"python-pip"
"qbittorrent"
"rocketchat-desktop"
"signal-desktop"
"soundux"
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
"xpadneo-dkms-git"
"youtube-dl"
"zsh"
)

yay=(
"cadmus-appimage"
"emulsion-bin"
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

# Install proton ge
echo "Installing Proton GE..."
sudo pip3 install protonup
protonup -d ~/.steam/root/compatibilitytools.d/
protonup -y

# Installing RPCS3
echo "Installing RPCS3..."
mkdir -p ~/.local/share/rpcs3/
wget --content-disposition https://rpcs3.net/latest-appimage -O ~/.local/share/rpcs3/rpcs3.AppImage
chmod a+x ~/.local/share/rpcs3/rpcs3.AppImage
cp settings/applications/rpcs3.desktop ~/.local/share/applications/rpcs3.desktop