{ config, lib, ... }:

let
  mapAttrsAndKeys = callback: list:
    (lib.foldl' (acc: value: acc // (callback value)) { } list);
in {
  home-manager.users = let
    users = lib.filter (user: config.system.user.${user}.enable == true)
      (lib.attrNames config.system.user);
  in mapAttrsAndKeys (user:
    let username = config.system.user.${user}.username;
    in {
      ${username} = lib.mkIf config.desktop.hypr {
        home.file.".config/hypr/hypr.conf".source = configs/hypr.conf;
      };
    }) users;
}
