#!/bin/bash

echo "Installing Fluent KDE theme..."
git clone https://github.com/vinceliuice/Fluent-kde.git
cd Fluent-kde || exit
latest=$(git describe --abbrev=0 --tags)
git checkout tags/"$latest"
cd ..
./Fluent-kde/install.sh --round

echo "Installing Monochrome KDE theme..."
git clone https://gitlab.com/pwyde/monochrome-kde.git
./monochrome-kde/install.sh -i
