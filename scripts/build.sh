EXTRAS="/etc/nixos/extras.nix"
CONFIG="/tmp/configuration-location"

[ ! -f "$EXTRAS" ] && echo "{}" | tee "$EXTRAS" > /dev/null

# Save current directory into a file
[ -f "$CONFIG" ] && rm "$CONFIG"
printf "$PWD" > "$CONFIG"

# Build the system configuration
nixos-rebuild switch --show-trace --impure --flake .#"$(cat /etc/hostname)"
