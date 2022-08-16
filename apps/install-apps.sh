# Install Proton GE updater
echo "Installing Proton GE updater..."
( (sudo pip3 install protonup-ng) && (mkdir -p ~/.local/share/Steam/compatibilitytools.d/) && (protonup -d ~/.local/share/Steam/compatibilitytools.d/) && (echo "Downloading latest proton ge...") && (yes | protonup) )
