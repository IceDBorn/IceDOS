{
  config,
  lib,
  ...
}:

let
  inherit (lib) mapAttrs mkIf;
  cfg = config.icedos;
in
mkIf (cfg.applications.kitty.enable) {
  home-manager.users = mapAttrs (user: _: {
    programs.kitty = {
      enable = (cfg.system.users.${user}.type != "server");
      settings = {
        background_opacity = "0.8";
        confirm_os_window_close = "0";
        cursor_shape = "beam";
        enable_audio_bell = "no";
        hide_window_decorations = if (cfg.applications.kitty.hideDecorations) then "yes" else "no";
        update_check_interval = "0";
        copy_on_select = "no";
        wayland_titlebar_color = "background";
      };

      font.name = "JetBrainsMono Nerd Font";
      font.size = 10;
      themeFile = "OneDark-Pro";
    };
  }) cfg.system.users;
}
