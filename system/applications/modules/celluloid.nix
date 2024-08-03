{
  config,
  pkgs,
  lib,
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
mkIf (cfg.applications.celluloid) {
  environment.systemPackages = [ pkgs.celluloid ];
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
          home.file.".config/celluloid" = mkIf (!cfg.hardware.devices.server.enable) {
            source = ../configs/celluloid;
            recursive = true;
          };

          dconf.settings = mkIf (!cfg.hardware.devices.server.enable) {
            "io/github/celluloid-player/celluloid" = {
              mpv-config-file = "file:///home/${username}/.config/celluloid/celluloid.conf";
            };

            "io/github/celluloid-player/celluloid" = {
              mpv-config-enable = true;
            };

            "io/github/celluloid-player/celluloid" = {
              always-append-to-playlist = true;
            };
          };
        };
      }
    ) users;
}
