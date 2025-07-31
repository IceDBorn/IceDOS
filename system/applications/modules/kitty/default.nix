{
  config,
  lib,
  ...
}:

let
  inherit (lib) mapAttrs mkIf;
  cfg = config.icedos;
  kitty = cfg.applications.kitty;
in
mkIf (kitty.enable) {
  home-manager.users = mapAttrs (user: _: {
    programs.kitty = {
      enable = true;
      settings = {
        background_opacity = "0.8";
        confirm_os_window_close = "0";
        cursor_shape = "beam";
        enable_audio_bell = "no";
        hide_window_decorations = if (kitty.hideDecorations) then "yes" else "no";
        update_check_interval = "0";
        copy_on_select = "no";
        wayland_titlebar_color = "background";
      };

      font.name = "JetBrainsMono Nerd Font";
      font.size = kitty.fontSize;
      themeFile = "OneDark-Pro";
    };

    wayland.windowManager.hyprland.settings.bind = mkIf (cfg.desktop.hyprland.enable) [
      "$mainMod, X, exec, kitty"
    ];

    dconf.settings = mkIf (cfg.desktop.gnome.enable) {
      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/kitty" = {
        binding = "<Super>x";
        command = "kitty";
        name = "Kitty";
      };

      "org/gnome/settings-daemon/plugins/media-keys".custom-keybindings = [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/kitty/"
      ];
    };
  }) cfg.system.users;
}
