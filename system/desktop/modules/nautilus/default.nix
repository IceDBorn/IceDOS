{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mapAttrs makeSearchPathOutput mkIf;
  cfg = config.icedos;
in
{
  environment = mkIf (cfg.applications.nautilus) {
    systemPackages = [ pkgs.nautilus ];

    gnome.excludePackages = mkIf (!cfg.applications.nautilus && cfg.desktop.gnome.enable) [
      pkgs.nautilus
    ];

    sessionVariables = {
      # Fix for missing audio/video information in properties https://github.com/NixOS/nixpkgs/issues/53631
      GST_PLUGIN_SYSTEM_PATH_1_0 = makeSearchPathOutput "lib" "lib/gstreamer-1.0" (
        with pkgs.gst_all_1;
        [
          gst-plugins-good
          gst-plugins-bad
          gst-plugins-ugly
          gst-libav
        ]
      ); # Fix from https://github.com/NixOS/nixpkgs/issues/195936#issuecomment-1366902737
    };
  };

  services.gvfs.enable = cfg.applications.nautilus;

  home-manager.users = mapAttrs (user: _: {
    dconf.settings = mkIf (cfg.applications.nautilus) {
      "org/gnome/nautilus/preferences" = {
        always-use-location-entry = true;
        show-create-link = true;
        show-delete-permanently = true;
      };

      "org/gnome/nautilus/icon-view" = {
        default-zoom-level = "small-plus";
      };

      "org/gtk/gtk4/settings/file-chooser" = {
        sort-directories-first = true;
        show-hidden = true;
      };

      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/nautilus" =
        mkIf (cfg.desktop.gnome.enable)
          {
            binding = "<Super>e";
            command = "nautilus .";
            name = "Nautilus";
          };

      "org/gnome/settings-daemon/plugins/media-keys".custom-keybindings = mkIf (cfg.desktop.gnome.enable
      ) [ "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/nautilus/" ];
    };

    home.file = mkIf (cfg.applications.nautilus) {
      "Templates/new".text = "";
      "Templates/new.cfg".text = "";
      "Templates/new.ini".text = "";
      "Templates/new.sh".text = "";
      "Templates/new.txt".text = "";
    };
  }) cfg.system.users;
}
