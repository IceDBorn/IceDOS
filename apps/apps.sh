# Add your apps install commands into this array
apps=(
"sudo pacman -S gimp"
"sudo pacman -S libreoffice"
"sudo pacman -S flatpak"
"sudo pacman -S qbittorrent"
"sudo pacman -S signal-desktop"
"sudo pacman -S vlc"
"sudo pacman -S grub-customizer"
"sudo pacman -S bpytop"
"sudo pacman -S wine"
"sudo pacman -S linux-headers"
"sudo pacman -S linux-lts-headers"
"sudo pacman -S papirus-icon-theme"
"sudo pacman -S npm"
"sudo pacman -S tree"
"yay -S jetbrains-toolbox"
"yay -S noto-fonts-emoji"
"yay -S balena-etcher"
"yay -S gwe"
"yay -S qalculate-gtk-nognome"
"yay -S anydesk-bin"
"yay -S persepolis"
"yay -S discord-canary"
"yay -S stremio"
"yay -S oh-my-zsh-git"
"yay -S tutanota-desktop"
"flatpak install flathub com.github.Eloston.UngoogledChromium"
)

# Install every app using commands inside of array
for command in "${!apps[@]}"
do
  eval "${apps[command]}"
done
