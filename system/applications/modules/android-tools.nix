{ config, lib, ... }:

let
  inherit (lib) mapAttrs mkIf;
  cfg = config.icedos;
in
mkIf (cfg.applications.android-tools) {
  programs.adb.enable = true;

  users.users = mapAttrs (user: _: {
    extraGroups = [ "adbusers" ];
  }) cfg.system.users;
}
