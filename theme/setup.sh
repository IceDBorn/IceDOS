#!/bin/bash

# Install Materia KDE theme
echo "Installing Materia KDE theme..."
wget -qO- https://raw.githubusercontent.com/PapirusDevelopmentTeam/materia-kde/master/install.sh | sh

# Set global KDE theme
echo "Setting Materia Dark as global theme..."
lookandfeeltool -a com.github.varlesh.materia-dark
