# Kitty config installer
echo "Installing kitty config..."
mkdir -p ~/.config/kitty/
cp apps/kitty.conf ~/.config/kitty/kitty.conf

# Flameshot config installer
echo "Installing flameshot config..."
mkdir -p ~/.config/flameshot/
cp apps/flameshot.ini ~/.config/kitty/flameshot.ini

# Mangohud config installer
echo "Installing mangohud config..."
mkdir -p ~/.config/MangoHud/
cp apps/MangoHud.conf ~/.config/MangoHud/MangoHud.conf