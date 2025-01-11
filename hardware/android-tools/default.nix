{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mapAttrs mkIf;
  cfg = config.icedos;
in
mkIf (cfg.applications.android-tools) {
  environment.systemPackages = [ pkgs.scrcpy ];
  programs.adb.enable = true;

  users.users = mapAttrs (user: _: {
    extraGroups = [ "adbusers" ];
  }) cfg.system.users;
}
