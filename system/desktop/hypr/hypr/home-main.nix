{ config, lib, ... }:

lib.mkIf (config.main.user.enable && config.desktop-environment.hypr.enable) {
  home-manager.users.${config.main.user.username} = {
    home.file = {
      ".config/hypr/hypr.conf" = {
        source = ../../../configs/hypr/hypr.conf;
        recursive = true;
      };
    };
  };
}
