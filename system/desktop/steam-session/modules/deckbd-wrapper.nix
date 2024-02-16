{ pkgs, lib, config, ... }:

let
  deckbd = "${pkgs.deckbd}/bin/deckbd";
  enable = config.applications.steam.session.steamdeck;
in lib.mkIf enable {
  boot.initrd = {
    preLVMCommands = ''
      DECKBD_RETRIES=10
      while true; do
        ${deckbd} query && break
        if [ "$DECKBD_RETRIES" -eq "0" ]; then break; fi
        sleep 1

        if [ "$DECKBD_RETRIES" -eq "1" ]; then
          echo -en "\rwaiting for deck controller to appear, $DECKBD_RETRIES retry remaining...   \n"
        else
          echo -en "\rwaiting for deck controller to appear, $DECKBD_RETRIES retries remaining..."
        fi
        DECKBD_RETRIES=$((DECKBD_RETRIES - 1))
      done

      if [ ! "$DECKBD_RETRIES" -eq "0" ]; then
        echo -en "starting deckbd...\n"
        ${deckbd} &
        DECKBD_PID=$!
      fi
    '';

    postMountCommands = ''
      [ $DECKBD_PID ] && kill $DECKBD_PID
    '';

    kernelModules = [ "uinput" "evdev" "hid_steam" ];
  };
}
