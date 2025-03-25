{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mapAttrs mkIf;
  cfg = config.icedos.hardware.networking.wg-quick;
in
mkIf (cfg.enable) {
  networking.wg-quick.interfaces = builtins.listToAttrs (
    map (name: {
      inherit name;

      value = {
        configFile = "/etc/wireguard/${name}.conf";
      };
    }) cfg.interfaces
  );

  environment.systemPackages = [
    (pkgs.writeShellScriptBin "wg-add-config-file" ''
      sudo bash -c '
        set -e
        newFile="/etc/wireguard/''$(basename $1)"

        mkdir -p /etc/wireguard
        umask 0022 /etc/wireguard

        cp "$1" "$newFile"
        chmod 600 "$newFile"
        rm "$1"
      ' -- $@
    '')
  ];
}
