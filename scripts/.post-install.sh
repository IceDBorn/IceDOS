#!/bin/bash

# Enable nvidia wayland support
(lspci | grep -i '.* vga .* nvidia .*' > /dev/null) && (echo "Enabling NVIDIA wayland support..."
sudo ln -s /dev/null /etc/udev/rules.d/61-gdm.rules
gsettings set org.gnome.mutter experimental-features '["kms-modifiers"]'
sudo mkinitcpio -P
sudo sed -i "/^GRUB_CMDLINE_LINUX_DEFAULT=/ s/\"$/ nvidia-drm.modeset=1\"/" /etc/default/grub
sudo grub-mkconfig -o /boot/grub/grub.cfg
sudo pacman -Syu --needed --noconfirm xorg-xwayland libxcb egl-wayland)

# Enable fractional scaling
echo "Enabling fractional scaling..."
gsettings set org.gnome.mutter experimental-features "['scale-monitor-framebuffer']"

# Change GTK theme
echo "Changing GTK theme to Plata-Noir-Compact..."
gsettings set org.gnome.desktop.interface gtk-theme Plata-Noir-Compact

# Change icon theme
echo "Changing icon theme to Tela-black-dark..."
gsettings set org.gnome.desktop.interface icon-theme Tela-black-dark

# Change color scheme to dark
echo "Enabling GNOME dark mode..."
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'

# Enable extensions
echo "Enabling gnome extensions..."
gsettings set org.gnome.shell disable-user-extensions false
gnome-extensions enable material-shell@papyelgringo
gnome-extensions enable trayIconsReloaded@selfmade.pl
gnome-extensions enable clipboard-indicator@tudmotu.com

# Remove script from startup
echo "Removing script from startup"
sudo rm -rf ~/.config/autostart/post-install.desktop
sudo rm -rf ~/.post-install.sh
