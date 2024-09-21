{ config, lib, ... }:

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
mkIf (cfg.applications.kitty.enable) {
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
          programs.kitty = {
            enable = (user != "server");
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
        };
      }
    ) users;
}
