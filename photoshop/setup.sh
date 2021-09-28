#!/bin/bash

echo "Installing Photoshop"
git clone https://github.com/Gictorbit/photoshopCClinux.git
cd photoshopCClinux || exit
sudo chmod +x setup.sh
./setup.sh
