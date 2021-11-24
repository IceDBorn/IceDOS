#!/bin/bash

username=$(whoami)

echo "Changing settings..."

# Clicking on files or folders selects them instead of opening them
echo "Editing single click behavior..."
sed -i '/KDE/a SingleClick=false' ~/.config/kdeglobals

# Enables bluetooth audio devices
echo "Enabling headphones support for bluetooth..."
sed -i '/General/a Enable=Source,Sink,Media,Socket' /etc/bluetooth/main.conf

# Add autostart items
echo "Adding autostart items..."
cp -a settings/autostart ~/.config/

# Remove guest account
echo "Removing guest account..."
sudo pacman -Rd systemd-guest-user

# Auto mount disks on startup
echo "Adding mounts to fstab..."
cat /etc/fstab settings/fstab > ~/.fstab.new
sudo mv /etc/fstab /etc/fstab.old
sudo mv ~/.fstab.new /etc/fstab

# Maximize nvidia GPU power limit on startup
echo "Maximizing GPU power limit..."
sudo cp settings/nv-power-limit.sh /usr/local/sbin/nv-power-limit.sh
sudo chmod 744 /usr/local/sbin/nv-power-limit.sh
sudo mkdir /usr/local/etc/systemd
sudo cp settings/nv-power-limit.service /usr/local/etc/systemd/nv-power-limit.service
sudo chmod 644 /usr/local/etc/systemd/nv-power-limit.service
sudo ln -s /usr/local/etc/systemd/nv-power-limit.service /etc/systemd/system/nv-power-limit.service
sudo systemctl start nv-power-limit.service
sudo systemctl enable nv-power-limit.service

# Enable Signal's tray icon
echo "Enabling signal's tray icon..."
sudo cp settings/autostart/signal-desktop.desktop ~/.local/share/applications/signal-desktop.desktop

# Set hard/soft memlock limits to 2 GBs (required by RPCS3)
echo "Setting hard/soft memlock limits to 2 GBs..."
cat /etc/security/limits.conf settings/limits.txt > /etc/security/limits.conf.new
mv /etc/security/limits.conf /etc/security/limits.conf.old
mv /etc/security/limits.conf.new /etc/security/limits.conf

# Pictures
echo "Adding pictures to the Pictures directory..."
cp pictures/arcolinux-hello.png ~/Pictures/.arcolinux-hello.png
cp pictures/wallpaper.png ~/Pictures/.wallpaper.png

# SDDM config
echo "Installing SDDM config..."
sudo mkdir -p /etc/sddm.conf.d/
sudo cp kde-theme/kde_settings.conf /etc/sddm.conf.d/kde_settings.conf

# nvm installer
echo "Installing nvm..."
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash

# Enable ssh
echo "Enabling ssh..."
sudo systemctl enable sshd

# Default steam to start to tray
echo "Defaulting steam to start to tray..."
sudo cp settings/autostart/steam.desktop ~/.local/share/applications/steam.desktop

# Default soundux to start to tray
echo "Defaulting soundux to start to tray..."
sudo cp settings/autostart/soundux.desktop ~/.local/share/applications/soundux.desktop

# Custom desktop files
echo "Installing custom desktop files..."
sudo cp -a settings/applications/ ~/.local/share/

# Generate GPG key
echo "Generating GPG key..."
gpg --gen-key

# Create folders for HDD mounts and change permissions
mkdir ~/Games
mkdir ~/Storage
sudo chown "$username":"$username" Games --recursive
sudo chown "$username":"$username" Storage --recursive

# Install KDE wallpaper engine plugin
echo "Installing KDE wallpaper engine plugin..."
git clone https://github.com/catsout/wallpaper-engine-kde-plugin.git
plasmapkg2 -i wallpaper-engine-kde-plugin/plugin
