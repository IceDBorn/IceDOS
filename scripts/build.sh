EXTRAS="/etc/nixos/extras.nix"
CONFIG="/tmp/configuration-location"
FLAKE="flake.nix"

[ ! -f "$EXTRAS" ] && echo "{}" | tee "$EXTRAS" > /dev/null

# Save current directory into a file
[ -f "$CONFIG" ] && rm -f "$CONFIG"
printf "$PWD" > "$CONFIG"

# Generate flake.nix
[ -f "$FLAKE" ] && rm -f "$FLAKE"
nix eval --write-to "$FLAKE" --file "genflake.nix" "$FLAKE"
nixfmt "$FLAKE"

# Build the system configuration
nixos-rebuild switch --show-trace --impure --flake .#"$(cat /etc/hostname)"
