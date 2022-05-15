#!/bin/bash

# Enable fractional scaling
echo "Enabling fractional scaling..."
gsettings set org.gnome.mutter experimental-features "['scale-monitor-framebuffer']"

# Change GTK theme
echo "Changing GTK theme to Plata-Noir-Compact..."
gsettings set org.gnome.desktop.interface gtk-theme Plata-Noir-Compact

# Change icon theme
echo "Changing icon theme to Tela-black-dark..."
gsettings set org.gnome.desktop.interface icon-theme Tela-black-dark
