{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) mapAttrs mkIf;
  cfg = config.icedos;
in
mkIf (cfg.applications.celluloid) {
  environment.systemPackages = with pkgs; [
    (writeShellScriptBin "celluloid-hdr" "ENABLE_HDR_WSI=1 celluloid --mpv-profile=HDR $@")
    celluloid
  ];

  home-manager.users = mapAttrs (user: _: {
    home.file.".config/celluloid" = {
      source = ./config;
      recursive = true;
    };

    dconf.settings = {
      "io/github/celluloid-player/celluloid" = {
        mpv-config-file = "file:///home/${user}/.config/celluloid/celluloid.conf";
      };

      "io/github/celluloid-player/celluloid" = {
        mpv-config-enable = true;
      };

      "io/github/celluloid-player/celluloid" = {
        always-append-to-playlist = true;
      };
    };
  }) cfg.system.users;
}
