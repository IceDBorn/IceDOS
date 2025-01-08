#! /usr/bin/env nix-shell
#! nix-shell -i bash -p nixfmt-rfc-style git nh

CONFIG="/tmp/configuration-location"
FLAKE="flake.nix"

action="switch"
extraBuildArgs=()

while [[ $# -gt 0 ]]; do
  case $1 in
    --boot)
      action="boot"
      shift
      ;;
    --update)
      update="-u"
      shift
      ;;
    --ask)
      ask="-a"
      shift
      ;;
    --builder)
      extraBuildArgs+=("--build-host")
      extraBuildArgs+=("$2")
      shift
      shift
      ;;
    *)
      echo "Unknown arg $1" >/dev/stderr
      exit 1
      ;;
  esac
done

# Save current directory into a file
[ -f "$CONFIG" ] && rm -f "$CONFIG"
printf "$PWD" > "$CONFIG"

# Generate flake.nix
[ -f "$FLAKE" ] && rm -f "$FLAKE"
nix eval --extra-experimental-features nix-command --write-to "$FLAKE" --file "genflake.nix" "$FLAKE"
nixfmt "$FLAKE"

# Build the system configuration
nh os $action . $update $ask ${extraBuildArgs[*]}
