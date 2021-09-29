# Add your apps install commands into this array
apps=(
"sudo pacman -S --needed git base-devel yay --noconfirm"
"sudo pacman -S bpytop --noconfirm"
"sudo pacman -S etcher --noconfirm"
"sudo pacman -S flameshot --noconfirm"
"sudo pacman -S godot-mono --noconfirm"
"sudo pacman -S gwe --noconfirm"
"sudo pacman -S jetbrains-toolbox --noconfirm"
"sudo pacman -S kcalc --noconfirm"
"sudo pacman -S kitty --noconfirm"
"sudo pacman -S libreoffice-fresh --noconfirm"
"sudo pacman -S linux-zen --noconfirm"
"sudo pacman -S linux-zen-headers --noconfirm"
"sudo pacman -S mullvad-vpn --noconfirm"
"sudo pacman -S noto-fonts-emoji --noconfirm"
"sudo pacman -S npm --noconfirm"
"sudo pacman -S nvidia-dkms --noconfirm"
"sudo pacman -S papirus-icon-theme --noconfirm"
"sudo pacman -S qbittorrent --noconfirm"
"sudo pacman -S signal-desktop --noconfirm"
"sudo pacman -S stremio --noconfirm"
"sudo pacman -S sublime-text-4 --noconfirm"
"sudo pacman -S sunshine --noconfirm"
"sudo pacman -S tree --noconfirm"
"sudo pacman -S tutanota-desktop --noconfirm"
"sudo pacman -S ungoogled-chromium --noconfirm"
"sudo pacman -S vlc --noconfirm"
"sudo pacman -S wine --noconfirm"
"sudo pacman -S winetricks --noconfirm"
"sudo pacman -S zsh --noconfirm"
"yay -S cadmus-appimage --noconfirm"
)

# Install every app using commands inside of array
for command in "${!apps[@]}"
do
  eval "${apps[command]}"
done
