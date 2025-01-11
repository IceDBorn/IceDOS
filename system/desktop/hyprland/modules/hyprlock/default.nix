{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) filterAttrs mapAttrs;
  cfg = config.icedos;

  getModules =
    path:
    builtins.map (dir: ./. + ("/modules/" + dir)) (
      builtins.attrNames (filterAttrs (_: v: v == "directory") (builtins.readDir path))
    );
in
{
  imports = getModules (./modules);
  environment.systemPackages = with pkgs; [ sysstat ];
  programs.hyprlock.enable = true;

  home-manager.users = mapAttrs (user: _: {
    home.file.".config/hypr/hyprlock.conf".source = ./hyprlock.conf;
  }) cfg.system.users;
}
