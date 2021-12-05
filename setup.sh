#!/bin/bash

username=$(whoami)

echo "Hello $username!"

# Mark chmod script as executable
sudo chmod +x scripts/chmod.sh

# Mark child scripts as executables
./scripts/chmod.sh

# Applications installer
./apps/apps.sh

# Application configs installer
./apps/configs.sh

# Settings changer
./settings/settings.sh

# Zsh installer
./zsh/install.sh

# Photoshop installer
./photoshop/setup.sh

# Rebooting sequence
./scripts/reboot.sh
