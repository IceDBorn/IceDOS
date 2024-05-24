{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib)
    attrNames
    filter
    foldl'
    mkIf
    ;

  cfg = config.icedos;

  mapAttrsAndKeys = callback: list: (foldl' (acc: value: acc // (callback value)) { } list);
in
mkIf (cfg.applications.brave) {
  environment.systemPackages = [ pkgs.brave ];

  home-manager.users =
    let
      users = filter (user: cfg.system.user.${user}.enable == true) (attrNames cfg.system.user);
    in
    mapAttrsAndKeys (
      user:
      let
        username = cfg.system.user.${user}.username;
      in
      {
        # Enable wayland support for brave
        ${username}.xdg.desktopEntries.brave-browser = {
          exec = "brave --enable-features=UseOzonePlatform --ozone-platform=wayland";
          icon = "brave";
          name = "Brave";
          terminal = false;
          type = "Application";
        };
      }
    ) users;
}
