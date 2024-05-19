{
  pkgs,
  lib,
  config,
  ...
}:

let
  inherit (lib) mkIf;

  cfg = config.icedos;

  deckbd = "${pkgs.deckbd}/bin/deckbd";
in
mkIf (cfg.hardware.steamdeck) {
  boot.initrd = {
    preLVMCommands = ''
      DECKBD_RETRIES=10
      while true; do
        ${deckbd} query && break
        if [ "$DECKBD_RETRIES" -eq "0" ]; then break; fi
        sleep 1

        if [ "$DECKBD_RETRIES" -eq "1" ]; then
          echo -en "\rwaiting for deck controller to appear, $DECKBD_RETRIES retry remaining...  "
        else
          echo -en "\rwaiting for deck controller to appear, $DECKBD_RETRIES retries remaining..."
        fi
        DECKBD_RETRIES=$((DECKBD_RETRIES - 1))
      done

      if [ ! "$DECKBD_RETRIES" -eq "0" ]; then
        echo -en "\nstarting deckbd...\n"
        ${deckbd} &
        DECKBD_PID=$!
      fi
    '';

    postMountCommands = ''
      [ $DECKBD_PID ] && kill $DECKBD_PID
    '';

    kernelModules = [
      "uinput"
      "evdev"
      "hid_steam"
    ];
  };

  environment.systemPackages = mkIf (cfg.applications.steam.session.enable) [
    pkgs.steamdeck-firmware
  ];
}
