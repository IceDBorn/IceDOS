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
{
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
          gtk = {
            enable = true;

            theme = {
              name = "adw-gtk3-dark";
              package = pkgs.adw-gtk3;
            };

            cursorTheme.name = "Bibata-Modern-Classic";
            iconTheme.name = "Tela-black-dark";
          }; # Change GTK themes

          dconf.settings = {
            # Enable dark mode
            "org/gnome/desktop/interface".color-scheme = "prefer-dark";

            # Nautilus
            "org/gnome/nautilus/preferences" = {
              always-use-location-entry = true;
            };

            "org/gtk/gtk4/settings/file-chooser" = {
              sort-directories-first = true;
              show-hidden = true;
            };

            # GTK file picker
            "org/gtk/settings/file-chooser" = {
              sort-directories-first = true;
              date-format = "with-time";
              show-type-column = false;
              show-hidden = true;
            };
          };

          xdg = {
            # Force creation of mimeapps
            configFile."mimeapps.list".force = true;

            # Default apps
            mimeApps = {
              enable = true;

              defaultApplications = {
                "application/pdf" = "librewolf.desktop";
                "application/x-bittorrent" = "de.haeckerfelix.Fragments.desktop";
                "application/x-ms-dos-executable" = "wine.desktop";
                "application/x-shellscript" = "codium.desktop";
                "application/x-wine-extension-ini" = "codium.desktop";
                "application/zip" = "org.gnome.FileRoller.desktop";
                "image/avif" = "org.gnome.gThumb.desktop";
                "image/jpeg" = "org.gnome.gThumb.desktop";
                "image/png" = "org.gnome.gThumb.desktop";
                "image/svg+xml" = "org.gnome.gThumb.desktop";
                "text/html" = "librewolf.desktop";
                "text/plain" = "codium.desktop";
                "video/mp4" = "io.github.celluloid_player.Celluloid.desktop";
                "video/x-matroska" = "io.github.celluloid_player.Celluloid.desktop";
                "x-scheme-handler/about" = "librewolf.desktop";
                "x-scheme-handler/http" = "librewolf.desktop";
                "x-scheme-handler/https" = "librewolf.desktop";
                "x-scheme-handler/unknown" = "librewolf.desktop";
              };
            };
          };

          home.file = {
            # New document options for nautilus
            "Templates/new".text = "";
            "Templates/new.cfg".text = "";
            "Templates/new.ini".text = "";
            "Templates/new.sh".text = "";
            "Templates/new.txt".text = "";

            ".icons/default" = {
              source = "${pkgs.bibata-cursors}/share/icons/Bibata-Modern-Classic";
              recursive = true;
            }; # Set icon theme fot QT apps and Hyprland
          };
        };
      }
    ) users;
}
