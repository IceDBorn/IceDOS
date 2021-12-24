#!/bin/bash

# Set global KDE theme
echo "Setting Materia Dark as global theme..."
lookandfeeltool -a com.github.varlesh.materia-dark

echo "Installing Photoshop..."
git clone https://github.com/Gictorbit/photoshopCClinux.git
(cd photoshopCClinux && sudo chmod +x setup.sh && ./setup.sh)
rm -rf photoshopCClinux

echo "Removing post install script..."
rm -rf ~/post-install.sh ~/.config/autostart/post-install.desktop
