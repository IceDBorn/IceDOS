{ config, lib, ... }:

lib.mkIf (config.work.user.enable && config.desktop-environment.hypr.enable) {
  home-manager.users.${config.work.user.username} = {
    home.file = {
      ".config/hypr/hypr.conf" = {
        source = ../../../configs/hypr/hypr.conf;
        recursive = true;
      };
    };
  };
}
