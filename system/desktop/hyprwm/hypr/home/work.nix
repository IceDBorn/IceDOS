{ config, lib, ... }:

lib.mkIf (config.system.user.work.enable && config.desktop.hypr.enable) {
  home-manager.users.${config.system.user.work.username} = {
    home.file.".config/hypr/hypr.conf".source =
      ../../../../applications/configs/hypr/hypr.conf;
  };
}
