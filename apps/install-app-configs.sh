#!/bin/bash

# Alacritty multiple terminals desktop file installer
echo "Installing alacritty multiple terminals desktop file..."
( (mkdir -p ~/.local/share/applications/) && (cp apps/startup/startup-terminals.desktop ~/.local/share/applications/startup-terminals.desktop) )
