#!/bin/bash

username=$(whoami)

echo "Changing settings..."

# Enables bluetooth audio devices
echo "Enabling headphones support for bluetooth..."
sed -i '/General/a Enable=Source,Sink,Media,Socket' /etc/bluetooth/main.conf

# Add autostart items
echo "Adding autostart items..."
cp -a settings/autostart ~/.config/

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

# Enable nvidia overclocking
echo "Enabling nvidia overclocking..."
sudo nvidia-xconfig --cool-bits=31

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
sudo cp theme/sddm_settings.conf /etc/sddm.conf.d/sddm_settings.conf

# nvm installer
echo "Installing nvm..."
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash

# Enable ssh
echo "Enabling ssh..."
sudo systemctl enable sshd

# Enable bluetooth
echo "Enabling bluetooth..."
sudo systemctl enable bluetooth

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
mkdir ~/SSDGames
sudo chown "$username":"$username" Games --recursive
sudo chown "$username":"$username" Storage --recursive
sudo chown "$username":"$username" SSDGames --recursive

# Add feedback to sudo password
echo "Adding password feedback to sudo..."
echo "Defaults pwfeedback" | sudo tee -a /etc/sudoers

# Set global KDE theme
echo "Setting Materia Dark as global theme..."
lookandfeeltool -a com.github.varlesh.materia-dark

# Update grub
echo "Updating grub..."
sudo grub-mkconfig -o /boot/grub/grub.cfg
