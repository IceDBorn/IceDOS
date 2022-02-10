#!/bin/bash

# Kitty config installer
echo "Installing kitty config..."
mkdir -p ~/.config/kitty/
cp apps/configs/kitty.conf ~/.config/kitty/kitty.conf
mkdir -p /mnt/guest/.config/kitty/
cp apps/configs/kitty.conf /mnt/guest/.config/kitty/kitty.conf

# Flameshot config installer
echo "Installing flameshot config..."
mkdir -p /~.config/flameshot/
cp apps/configs/flameshot.ini ~/.config/flameshot/flameshot.ini
mkdir -p /mnt/guest/.config/flameshot/
cp apps/configs/flameshot.ini /mnt/guest/.config/flameshot/flameshot.ini

# Mangohud config installer
echo "Installing mangohud config..."
mkdir -p ~/.config/MangoHud/
cp apps/configs/MangoHud.conf ~/.config/MangoHud/MangoHud.conf
mkdir -p /mnt/guest/.config/MangoHud/
cp apps/configs/MangoHud.conf /mnt/guest/.config/MangoHud/MangoHud.conf

# Sunshine config installer
echo "Installing sunshine config..."
mkdir -p ~/.config/sunshine/
cp apps/configs/sunshine.conf ~/.config/sunshine/sunshine.conf
mkdir -p /mnt/guest/.config/sunshine/
cp apps/configs/sunshine.conf /mnt/guest/.config/sunshine/sunshine.conf

# Bpytop config installer
mkdir -p ~/.config/bpytop
cp apps/configs/bpytop.conf ~/.config/bpytop/bpytop.conf
mkdir -p /mnt/guest/.config/bpytop
cp apps/configs/bpytop.conf /mnt/guest/.config/bpytop/bpytop.conf