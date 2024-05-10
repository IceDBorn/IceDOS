{ config, lib, ... }:
let
  inherit (lib)
    attrNames
    filter
    foldl'
    mkIf
    ;

  cfg = config.icedos;

  mapAttrsAndKeys = callback: list: (foldl' (acc: value: acc // (callback value)) { } list);
  users = filter (user: cfg.system.user.${user}.enable == true) (attrNames cfg.system.user);
in
mkIf (cfg.applications.android-tools) {
  programs.adb.enable = true;

  users.users = mapAttrsAndKeys (
    user:
    let
      username = cfg.system.user.${user}.username;
    in
    {
      ${username}.extraGroups = [ "adbusers" ];
    }
  ) users;
}
