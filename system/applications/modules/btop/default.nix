{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) attrNames filter foldl';
  cfg = config.icedos;
  mapAttrsAndKeys = callback: list: (foldl' (acc: value: acc // (callback value)) { } list);
in
{
  environment.systemPackages = [
    pkgs.btop
  ];

  home-manager.users =
    let
      users = filter (user: cfg.system.users.${user}.enable == true) (attrNames cfg.system.users);
    in
    mapAttrsAndKeys (
      user:
      let
        username = cfg.system.users.${user}.username;
      in
      {
        ${username} = {
          home.file.".config/btop/btop.conf".source = ./btop.conf;
        };
      }
    ) users;
}
