#!/bin/bash

# Clicking on files or folders selects them instead of opening them
sed -i '/KDE/a SingleClick=false' ~/.config/kdeglobals

# Add autostart items
sudo rm -rfv ~/.config/autostart/*
cp -a settings/autostart ~/.config/autostart

# Remove guest account
sudo pacman -Rd systemd-guest-user
