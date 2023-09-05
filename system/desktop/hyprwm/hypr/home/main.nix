{ config, lib, ... }:

lib.mkIf (config.system.user.main.enable && config.desktop.hypr.enable) {
  home-manager.users.${config.system.user.main.username} = {
    home.file = {
      ".config/hypr/hypr.conf" = {
        source = ../../../../applications/configs/hypr/hypr.conf;
        recursive = true;
      };
    };
  };
}
