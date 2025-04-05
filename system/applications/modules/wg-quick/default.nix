{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) listToAttrs mkIf;
  cfg = config.icedos.hardware.networking.wg-quick;
in
mkIf (cfg.enable) {
  networking.wg-quick.interfaces = listToAttrs (
    map (name: {
      inherit name;

      value = {
        configFile = "/etc/wireguard/${name}.conf";
      };
    }) cfg.interfaces
  );

  icedos.internals.toolset.commands = [
    (
      let
        command = "wg-config";
      in
      {
        bin = "${pkgs.writeShellScript command ''
          sudo bash -c '
            set -e

            if [[ "$1" == "" ]]; then
              echo "error: provide config file location as an argument"
              exit 1
            fi

            newFile="/etc/wireguard/''$(basename $1)"

            mkdir -p /etc/wireguard
            umask 0022 /etc/wireguard

            cp "$1" "$newFile"
            chmod 600 "$newFile"
            rm "$1"
          ' -- $@
        ''}";
        command = command;
        help = "add wireguard config to /etc/wireguard";
      }
    )
  ];
}
