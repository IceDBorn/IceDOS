#!/bin/bash

username=$(whoami)

# Clicking on files or folders selects them instead of opening them
sed -i '/KDE/a SingleClick=false' ~/.config/kdeglobals

# Enables bluetooth headphones
sed -i '/General/a Enable=Source,Sink,Media,Socket' /etc/bluetooth/main.conf

# Add autostart items
cp -a settings/autostart ~/.config/

# Remove guest account
sudo pacman -Rd systemd-guest-user

# Enable sunshine service
systemctl --machine="$username"@.host --user enable sunshine

# Auto mount disks on startup
cat /etc/fstab settings/fstab > ~/.fstab.new
sudo mv /etc/fstab /etc/fstab.old
sudo mv ~/.fstab.new /etc/fstab
