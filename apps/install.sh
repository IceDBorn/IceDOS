# Add your apps install commands into this array
apps=(
"sudo pacman -S --needed git base-devel yay"
"sudo pacman -S bpytop"
"sudo pacman -S etcher"
"sudo pacman -S flameshot"
"sudo pacman -S gwe"
"sudo pacman -S jetbrains-toolbox"
"sudo pacman -S kcalc"
"sudo pacman -S kitty"
"sudo pacman -S libreoffice-fresh"
"sudo pacman -S linux-zen"
"sudo pacman -S linux-zen-headers"
"sudo pacman -S noto-fonts-emoji"
"sudo pacman -S npm"
"sudo pacman -S nvidia-dkms"
"sudo pacman -S papirus-icon-theme"
"sudo pacman -S qbittorrent"
"sudo pacman -S signal-desktop"
"sudo pacman -S stremio"
"sudo pacman -S sublime-text-4"
"sudo pacman -S tree"
"sudo pacman -S tutanota-desktop"
"sudo pacman -S ungoogled-chromium"
"sudo pacman -S vlc"
"sudo pacman -S wine"
"sudo pacman -S zsh"
"yay -S cadmus-appimage"
)

# Install every app using commands inside of array
for command in "${!apps[@]}"
do
  eval "${apps[command]}"
done
