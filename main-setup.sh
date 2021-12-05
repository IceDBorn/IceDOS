#!/bin/bash

username=$(whoami)

echo "Hello $username!"

# Mark chmod script as executable
sudo chmod +x scripts/chmod.sh

# Mark child scripts as executables
./scripts/chmod.sh

# Applications installer
./apps/install-apps.sh

# Application configs installer
./apps/install-app-configs.sh

# Settings changer
./settings/settings.sh

# Zsh installer
./apps/zsh/zsh-setup.sh

# Photoshop installer
./apps/install-photoshop.sh

# Rebooting sequence
./scripts/reboot.sh
