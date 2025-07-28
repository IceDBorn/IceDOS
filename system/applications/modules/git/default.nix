{
  config,
  lib,
  ...
}:

let
  inherit (lib) mapAttrs;
  cfg = config.icedos;
in
{
  home-manager.users = mapAttrs (user: _: {
    programs.git = {
      enable = true;
      userName = "${cfg.system.users.${user}.applications.git.username}";
      userEmail = "${cfg.system.users.${user}.applications.git.email}";
    };
  }) cfg.system.users;
}
