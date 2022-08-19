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

# Enable extensions
echo "Enabling gnome extensions..."
gnome-extensions enable material-shell@papyelgringo
gnome-extensions enable trayIconsReloaded@selfmade.pl
gnome-extensions enable clipboard-indicator@tudmotu.com
gnome-extensions enable gsconnect@andyholmes.github.io
gnome-extensions enable sound-output-device-chooser@kgshank.net
gnome-extensions enable bluetooth-quick-connect@bjarosze.gmail.com
gnome-extensions enable arch-update@RaphaelRochet
gnome-extensions enable color-picker@tuberry
gnome-extensions enable gamemode@christian.kellner.me
gnome-extensions enable CoverflowAltTab@dmo60.de
gnome-extensions enable volume-mixer@evermiss.net

# Remove script from startup
echo "Removing script from startup"
sudo rm -rf ~/.config/autostart/post-install.desktop
sudo rm -rf ~/.post-install.sh
