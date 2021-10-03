#!/bin/bash

# Clicking on files or folders selects them instead of opening them
echo "Editing single click behavior..."
sed -i '/KDE/a SingleClick=false' ~/.config/kdeglobals

# Enables bluetooth headphones
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
cp settings/autostart/signal-desktop.desktop ~/.local/share/applications/signal-desktop.desktop
