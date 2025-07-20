#! /usr/bin/env nix-shell
#! nix-shell -i bash -p git nh nixfmt-rfc-style rsync

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
      update="1"
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
[ -f "$CONFIG" ] && rm -f "$CONFIG" || sudo rm -rf "$CONFIG"
printf "$PWD" > "$CONFIG"

# Generate flake.nix
[ -f "$FLAKE" ] && rm -f "$FLAKE"
nix eval --extra-experimental-features nix-command --write-to "$FLAKE" --file "genflake.nix" "$FLAKE"
nixfmt "$FLAKE"

[ "$update" == "1" ] && nix flake update

# Make a tmp folder and build from there
TMP_BUILD_FOLDER="$(mktemp -d -t icedos-build.XXXXXX | xargs echo)/"

mkdir -p "$TMP_BUILD_FOLDER"

rsync -a ./ "$TMP_BUILD_FOLDER" \
--exclude='.cache' \
--exclude='.editorconfig' \
--exclude='.git' \
--exclude='.gitignore' \
--exclude='.taplo.toml' \
--exclude='LICENSE' \
--exclude='README.md' \
--exclude='build.sh' \
--exclude='genflake.nix'

echo "Building from path $TMP_BUILD_FOLDER"

# Build the system configuration
nh os $action "$TMP_BUILD_FOLDER" $ask ${extraBuildArgs[*]}
