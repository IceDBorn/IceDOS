#!/bin/bash

# TODO: Simplify package install

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
"amd-ucode"
"blender"
"bluedevil"
"bluez-utils"
"bpytop"
"dolphin"
"duckstation-git"
"etcher"
"firefox-nightly"
"flameshot"
"gamemode"
"godot"
"gparted"
"gwe"
"jetbrains-toolbox"
"kcalc"
"kdeconnect"
"kdenlive"
"kitty"
"kvantum-theme-materia"
"lib32-mangohud"
"libreoffice-fresh"
"linux-zen"
"linux-zen-headers"
"lutris"
"mangohud"
"materia-gtk-theme"
"materia-kde"
"mullvad-vpn"
"noisetorch"
"noto-fonts-emoji"
"npm"
"ntfs-3g"
"nvidia"
"nvidia-dkms"
"nvtop"
"os-prober"
"papirus-icon-theme"
"paru"
"pcsx2"
"plasma"
"powerpill"
"ppsspp"
"protontricks"
"pulseaudio-bluetooth"
"python-pip"
"qbittorrent"
"qt5ct"
"sddm"
"sddm-kcm"
"signal-desktop"
"soundux"
"steam"
"steamtinkerlaunch"
"stremio"
"sublime-text-4"
"tree"
"tutanota-desktop"
"vlc"
"wine"
"winetricks"
"xpadneo-dkms-git"
"youtube-dl"
"zsh"
)

yay=(
"emulsion-bin"
"moonlight-qt"
"papirus-libreoffice-theme"
"rar"
"sunshine-git"
)

# Install Chaotic AUR as a pacman mirror
echo "Installing Chaotic AUR..."
sudo pacman-key --recv-key FBA220DFC880C036 --keyserver keyserver.ubuntu.com
sudo pacman-key --lsign-key FBA220DFC880C036
sudo pacman -U "https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst" "https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst"
echo "[chaotic-aur]" | sudo tee -a /etc/pacman.conf
echo "Include = /etc/pacman.d/chaotic-mirrorlist" | sudo tee -a /etc/pacman.conf
sudo pacman -Syyu
yay -Syyu

echo "Installing applications..."
# Install pacman packages
for command in "${!pacman[@]}"
do
  echo "${pacman[command]}" | tee -a temp >/dev/null
done
packagesList=$(cat temp)
sudo pacman -S "$packagesList" --noconfirm
rm -rf temp

# Install yay packages
for command in "${!yay[@]}"
do
  echo "${yay[command]}" | tee -a temp >/dev/null
done
packagesList=$(cat temp)
yay -S "$packagesList" --noconfirm
rm -rf temp

# Install Proton GE updater
echo "Installing Proton GE updater..."
sudo pip3 install protonup
protonup -d ~/.steam/root/compatibilitytools.d/
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
