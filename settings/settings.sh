#!/bin/bash

# Add noise suppression to pipewire
echo "Adding noise suppression to pipewire..."
( (mkdir -p ~/.config/pipewire) && (cp /usr/share/pipewire/pipewire.conf ~/.config/pipewire/pipewire.conf) && (sed -i "/libpipewire-module-session-manager/a $(cat settings/txt-to-append/noise-suppression.txt)" ~/.config/pipewire/pipewire.conf) )