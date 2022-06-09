#!/bin/bash

# Flameshot config installer
echo "Installing flameshot config..."
( (mkdir -p /~.config/flameshot/) && (cp apps/configs/flameshot.ini ~/.config/flameshot/flameshot.ini) )

# Mangohud config installer
echo "Installing mangohud config..."
( (mkdir -p ~/.config/MangoHud/) && (cp apps/configs/MangoHud.conf ~/.config/MangoHud/MangoHud.conf) )

# Sunshine config installer
echo "Installing sunshine config..."
( (mkdir -p ~/.config/sunshine/) && (cp apps/configs/sunshine.conf ~/.config/sunshine/sunshine.conf) )

# Alacritty config installer
echo "Installing alacritty config..."
( (mkdir -p ~/.config/alacritty/) && (cp apps/configs/alacritty.yml ~/.config/alacritty/alacritty.yml) )

# Alacritty multiple terminals desktop file installer
echo "Installing alacritty multiple terminals desktop file..."
( (mkdir -p ~/.local/share/applications/) && (cp apps/startup/startup-terminals.desktop ~/.local/share/applications/startup-terminals.desktop) )
