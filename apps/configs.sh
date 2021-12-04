#!/bin/bash

echo "Installing app configs..."

# Kitty config installer
echo "Installing kitty config..."
mkdir -p ~/.config/kitty/
cp apps/kitty.conf ~/.config/kitty/kitty.conf

# Flameshot config installer
echo "Installing flameshot config..."
mkdir -p ~/.config/flameshot/
cp apps/flameshot.conf ~/.config/flameshot/flameshot.conf

# Mangohud config installer
echo "Installing mangohud config..."
mkdir -p ~/.config/MangoHud/
cp apps/MangoHud.conf ~/.config/MangoHud/MangoHud.conf

# Sunshine config installer
echo "Installing sunshine config..."
mkdir -p ~/.config/sunshine/
cp apps/sunshine.conf ~/.config/sunshine/sunshine.conf