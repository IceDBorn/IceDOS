# PACKAGES INSTALLED ON WORK USER
{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:

let
  inherit (lib)
    foldl'
    lists
    mkIf
    splitString
    ;

  pkgMapper =
    pkgList: lists.map (pkgName: foldl' (acc: cur: acc.${cur}) pkgs (splitString "." pkgName)) pkgList;

  cfg = config.icedos.system;
  username = cfg.users.server.username;

  # Update the system configuration
  update = import ../../modules/rebuild.nix {
    inherit pkgs config;
    command = "update";
    update = "true";
  };
in
mkIf (cfg.users.server.enable) {
  users.users.${username}.packages = (pkgMapper (lib.importTOML ./packages.toml).packages) ++ [
    update
  ];
}
