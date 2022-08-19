#!/bin/bash

# Change GTK theme
echo "Changing GTK theme to Plata-Noir-Compact..."
gsettings set org.gnome.desktop.interface gtk-theme Plata-Noir-Compact

# Change icon theme
echo "Changing icon theme to Tela-black-dark..."
gsettings set org.gnome.desktop.interface icon-theme Tela-black-dark

# Change color scheme to dark
echo "Enabling GNOME dark mode..."
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'

# Remove script from startup
echo "Removing script from startup"
sudo rm -rf ~/.config/autostart/post-install.desktop
sudo rm -rf ~/.post-install.sh
