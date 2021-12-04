#!/bin/bash

username=$(whoami)

echo "Hello $username!"

# Mark chmod script as executable
sudo chmod +x scripts/chmod.sh

# Mark child scripts as executables
./scripts/chmod.sh

# KDE theme installer
./theme/setup.sh

# Applications installer
./apps/apps.sh

# Application configs installer
./apps/configs.sh

# Zsh installer
./zsh/install.sh

# Settings changer
./settings/settings.sh

# Photoshop installer
./photoshop/setup.sh

# Rebooting sequence
./scripts/reboot.sh
