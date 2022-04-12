#!/bin/bash

echo "Installing Photoshop..."
git clone https://github.com/Gictorbit/photoshopCClinux.git
(cd photoshopCClinux && sudo chmod +x setup.sh && ./setup.sh)
rm -rf photoshopCClinux

gsettings set org.gnome.desktop.background picture-uri file:///home/"$username"/Pictures/.wallpaper.png