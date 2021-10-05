#!/bin/bash

# Change "sddm" according to your display manager Ex. "gdm" for Gnome
systemctl stop display-manager

# Increase this value if you're experiencing dead-locks
sleep 1
