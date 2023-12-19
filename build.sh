
# Save current directory into a file
printf "$PWD" > /tmp/.configuration-location

# Build the system configuration
sudo nixos-rebuild switch --impure --flake .#"$(cat /etc/hostname)"
