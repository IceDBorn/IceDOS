#!/bin/bash

mkdir -p ~/.local/share/Steam/steamui/css/
cd ~/.local/share/Steam/steamui/css/

if ! test -f "library.css"; then
    echo "Steam library file not found, make sure that you have succesfully executed Steam once!"
    exit 1;
fi

if ! grep -Fxq "/*patched*/" library.css; then
    echo "Patching steam library..."
    mv library.css library.original.css
    touch library.css
    echo "/*patched*/
  @import url("https://steamloopback.host/css/library.original.css");
    @import url("https://steamloopback.host/libraryroot.custom.css");" >> library.css

    # Pad new library file until it has the same size as the original one
    truncate -r library.original.css library.css
else
    echo "Steam library is already patched..."
fi
