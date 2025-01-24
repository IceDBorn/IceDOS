{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mapAttrs;
  cfg = config.icedos;
  accentColor = cfg.internals.accentColor;
  audioPlayer = "io.bassi.Amberol.desktop";

  browser =
    {
      librewolf = "librewolf.desktop";
      zen = "zen.desktop";
    }
    .${cfg.applications.defaultBrowser};

  editor =
    {
      codium = "codium.desktop";
      zed = "dev.zed.Zed.desktop";
    }
    .${cfg.applications.defaultEditor};

  gtkCss = ''
    @define-color accent_bg_color ${accentColor};
    @define-color accent_color @accent_bg_color;

    :root {
      --accent-bg-color: @accent_bg_color;
    }
  '';

  imageViewer = "org.gnome.Loupe.desktop";
  videoPlayer = "io.github.celluloid_player.Celluloid.desktop";
in
{
  home-manager.users = mapAttrs (user: _: {
    gtk = {
      enable = true;

      theme = {
        name = "adw-gtk3-dark";
        package = pkgs.adw-gtk3;
      };

      cursorTheme = {
        name = "Bibata-Modern-Classic";
        package = pkgs.bibata-cursors;
      };

      iconTheme = {
        name = "Tela-black-dark";
        package = pkgs.tela-icon-theme;
      };

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
          "application/json" = editor;
          "application/pdf" = browser;
          "application/x-bittorrent" = "de.haeckerfelix.Fragments.desktop";
          "application/x-ms-dos-executable" = "wine.desktop";
          "application/x-shellscript" = editor;
          "application/x-wine-extension-ini" = editor;
          "application/x-zerosize" = editor;
          "application/xhtml_xml" = browser;
          "application/xhtml+xml" = browser;
          "application/zip" = "org.gnome.FileRoller.desktop";
          "audio/aac" = audioPlayer;
          "audio/flac" = audioPlayer;
          "audio/m4a" = audioPlayer;
          "audio/mp3" = audioPlayer;
          "audio/wav" = audioPlayer;
          "image/avif" = imageViewer;
          "image/jpeg" = imageViewer;
          "image/png" = imageViewer;
          "image/svg+xml" = imageViewer;
          "text/html" = browser;
          "text/plain" = editor;
          "video/mp4" = videoPlayer;
          "video/quicktime" = videoPlayer;
          "video/x-matroska" = videoPlayer;
          "video/x-ms-wmv" = videoPlayer;
          "x-scheme-handler/about" = browser;
          "x-scheme-handler/http" = browser;
          "x-scheme-handler/https" = browser;
          "x-scheme-handler/unknown" = browser;
          "x-www-browser" = browser;
        };
      };
    };

    home = {
      pointerCursor = {
        gtk.enable = true;
        x11.enable = true;
        package = pkgs.bibata-cursors;
        name = "Bibata-Modern-Classic";
        size = 24;
      };

      file.".config/gtk-4.0/gtk.css".text = gtkCss;
    };
  }) cfg.system.users;
}
