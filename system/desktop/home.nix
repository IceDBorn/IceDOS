{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) mapAttrs;
  cfg = config.icedos;

  browser =
    if (cfg.applications.librewolf.enable && cfg.applications.librewolf.default) then
      "librewolf.desktop"
    else if (cfg.applications.zen-browser.enable && cfg.applications.zen-browser.default) then
      "zen.desktop"
    else
      "";

  gtkCss = ''
    @define-color accent_bg_color ${cfg.desktop.gtkAccentColor};
    @define-color accent_color @accent_bg_color;
  '';
in
{
  home-manager.users = mapAttrs (user: _: {
    gtk = {
      enable = true;

      theme = {
        name = "adw-gtk3-dark";
        package = pkgs.adw-gtk3;
      };

      cursorTheme.name = "Bibata-Modern-Classic";
      iconTheme.name = "Tela-black-dark";

      gtk3.extraCss = gtkCss;
    };

    dconf.settings = {
      # Enable dark mode
      "org/gnome/desktop/interface".color-scheme = "prefer-dark";

      # GTK file picker
      "org/gtk/settings/file-chooser" = {
        sort-directories-first = true;
        date-format = "with-time";
        show-type-column = false;
        show-hidden = true;
      };
    };

    xdg = {
      configFile = {
        "gtk-4.0/gtk.css".enable = false;
        "mimeapps.list".force = true;
      };

      # Default apps
      mimeApps = {
        enable = true;

        defaultApplications = {
          "application/pdf" = browser;
          "application/x-bittorrent" = "de.haeckerfelix.Fragments.desktop";
          "application/x-ms-dos-executable" = "wine.desktop";
          "application/x-shellscript" = "codium.desktop";
          "application/x-wine-extension-ini" = "codium.desktop";
          "application/xhtml_xml" = browser;
          "application/xhtml+xml" = browser;
          "application/zip" = "org.gnome.FileRoller.desktop";
          "image/avif" = "org.gnome.gThumb.desktop";
          "image/jpeg" = "org.gnome.gThumb.desktop";
          "image/png" = "org.gnome.gThumb.desktop";
          "image/svg+xml" = "org.gnome.gThumb.desktop";
          "text/html" = browser;
          "text/plain" = "codium.desktop";
          "video/mp4" = "io.github.celluloid_player.Celluloid.desktop";
          "video/x-matroska" = "io.github.celluloid_player.Celluloid.desktop";
          "x-scheme-handler/about" = browser;
          "x-scheme-handler/http" = browser;
          "x-scheme-handler/https" = browser;
          "x-scheme-handler/unknown" = browser;
          "x-www-browser" = browser;
        };
      };
    };

    home.file = {
      ".icons/default" = {
        source = "${pkgs.bibata-cursors}/share/icons/Bibata-Modern-Classic";
        recursive = true;
      };

      ".config/gtk-4.0/gtk.css".text = gtkCss;
    };
  }) cfg.system.users;
}
