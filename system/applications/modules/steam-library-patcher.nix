{ pkgs, steamPath }:

pkgs.writeShellScriptBin "patch-steam-library" ''
  STEAM_LOOPBACK="https://steamloopback.host"

  mkdir -p "${steamPath}"
  cd "${steamPath}" || exit 1

  if ! test -f "library.css"; then
      echo "warning: steam library file not found, make sure that you have succesfully executed steam once."
      exit 1
  fi

  if ! grep -Fxq "/*patched*/" library.css; then
      echo "patching steam library..."
      mv library.css library.original.css
      touch library.css
      echo "/*patched*/
      @import url('$STEAM_LOOPBACK/css/library.original.css');
      @import url('$STEAM_LOOPBACK/libraryroot.custom.css');" >> library.css

      # Pad new library file until it has the same size as the original one
      truncate -r library.original.css library.css
  fi
''
