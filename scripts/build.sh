#! /usr/bin/env nix-shell
#! nix-shell -i bash -p nixfmt-rfc-style git

EXTRAS="/etc/nixos/extras.nix"
CONFIG="/tmp/configuration-location"
FLAKE="flake.nix"

[ ! -f "$EXTRAS" ] && echo "{}" | tee "$EXTRAS" > /dev/null

# Save current directory into a file
[ -f "$CONFIG" ] && rm -f "$CONFIG"
printf "$PWD" > "$CONFIG"

# Generate flake.nix
[ -f "$FLAKE" ] && rm -f "$FLAKE"
nix eval --extra-experimental-features nix-command --write-to "$FLAKE" --file "genflake.nix" "$FLAKE"
nixfmt "$FLAKE"

# Build the system configuration
nixos-rebuild switch --show-trace --impure --flake .#"$(cat /etc/hostname)"
