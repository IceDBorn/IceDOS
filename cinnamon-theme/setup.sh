#!/bin/bash

echo "Installing CBlack cinnamon theme..."
git clone https://github.com/linuxmint/cinnamon-spices-themes.git
mv CBlack ~/.themes/CBlack/
mv qob ~/.themes/qob/

echo "Installing Monochrome KDE theme..."
git clone https://gitlab.com/pwyde/monochrome-kde.git
./monochrome-kde/install.sh -i

echo "Installing grub 2 themes..."
git clone https://github.com/vinceliuice/grub2-themes.git
# -t [tela/vimix/stylish/slaze/whitesur] -i [color/white/whitesur] -s [1080p/2k/4k/ultrawide/ultrawide2k]
sudo ./grub2-themes/install.sh -t vimix -i white -s 1080p
