# Install GPU drivers
# You have to install the GPU/Vulkan drivers before installing Steam because Steam defaults to AMD vulkan drivers
(lspci | grep -i '.* vga .* nvidia .*' > /dev/null) && (echo "Installing NVIDIA GPU/Vulkan drivers..." && sudo pacman -S nvidia-open-dkms lib32-nvidia-utils nvidia-utils cuda nvidia-settings --noconfirm)
(lspci | grep -i '.* vga .* amd .*' > /dev/null) && (echo "Installing AMD Vulkan drivers..." && sudo pacman -S lib32-amdvlk --noconfirm)
(lspci | grep -i '.* vga .* intel .*' > /dev/null) && (echo "Installing INTEL Vulkan drivers..." && sudo pacman -S vulkan-intel lib32-vulkan-intel --noconfirm)

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
(lspci | grep -i '.* vga .* nvidia .*' > /dev/null) && (echo "Installing NVIDIA driver patch and GreenWithEnvy..." && paru -S nvlax-git gwe gpu-screen-recorder-gtk-git --noconfirm --skipreview)

# Install corectrl only on AMD GPUs
(lspci | grep -i '.* vga .* amd .*' > /dev/null) && (echo "Installing CoreCTRL..." && paru -S corectrl --noconfirm --skipreview)

# Install aur packages
echo "Installing aur packages..."
< apps/packages/aur.txt xargs paru -S --needed || exit

# Install Proton GE updater
echo "Installing Proton GE updater..."
( (sudo pip3 install protonup-ng) && (mkdir -p ~/.local/share/Steam/compatibilitytools.d/) && (protonup -d ~/.local/share/Steam/compatibilitytools.d/) && (echo "Downloading latest proton ge...") && (yes | protonup) )

# Install performance tweaks
echo "Installing performance tweaks..."
( (git clone https://gitlab.com/garuda-linux/themes-and-settings/settings/performance-tweaks.git) && (cd performance-tweaks && makepkg -si --noconfirm) && (rm -rf performance-tweaks) )
