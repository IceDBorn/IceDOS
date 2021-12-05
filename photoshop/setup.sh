#!/bin/bash

echo "Installing Photoshop..."
git clone https://github.com/Gictorbit/photoshopCClinux.git
(cd photoshopCClinux && sudo chmod +x setup.sh && ./setup.sh)
rm -rf photoshopCClinux
