{ config, pkgs, lib, ... }:

lib.mkIf config.system.user.work.enable {
  home-manager.users.${config.system.user.work.username} = {
    gtk = {
      enable = true;
      theme.name = "Adwaita-dark";
      cursorTheme.name = "Bibata-Modern-Classic";
      iconTheme.name = "Tela-black-dark";
    }; # Change GTK themes

    dconf.settings = {
      "org/gnome/nautilus/preferences" = {
        always-use-location-entry = true;
      }; # Nautilus path bar is always editable

      "org/gtk/gtk4/settings/file-chooser" = {
        sort-directories-first = true;
      }; # Nautilus sorts directories first

      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      }; # Enable dark mode
    };

    xdg = {
      # Force creation of mimeapps
      configFile."mimeapps.list".force = true;

      desktopEntries = {
        # Codium profile used a an IDE
        codiumIDE = {
          exec =
            "codium --user-data-dir ${config.system.home}/${config.system.user.work.username}/.config/VSCodiumIDE";
          icon = "codium";
          name = "Codium IDE";
          terminal = false;
          type = "Application";
        };

        # dbeaver on Xwayland (fix scaling issues)
        dbeaver = {
          exec = "env GDK_BACKEND=x11 dbeaver";
          icon = "dbeaver";
          name = "dbeaver - X11";
          terminal = false;
          type = "Application";
        };

        # Firefox PWA
        pwas = {
          exec =
            "firefox --no-remote -P PWAs --name pwas ${config.applications.firefox.pwas.sites}";
          icon = "firefox-nightly";
          name = "Firefox PWAs";
          terminal = false;
          type = "Application";
        };

        # Run signal without a tray icon
        signal = {
          exec = "signal-desktop --hide-tray-icon";
          icon = "signal-desktop";
          name = "Signal - No tray";
          terminal = false;
          type = "Application";
        };

        # Force slack to use window decorations
        slack = {
          name = "Slack";
          exec = "slack --enable-features=WaylandWindowDecorations";
          icon = "slack";
          settings = { StartupWMClass = "slack"; };
        };
      };

      mimeApps = {
        enable = true;

        # Default apps
        defaultApplications = {
          "application/pdf" = "firefox.desktop";
          "application/x-bittorrent" = "de.haeckerfelix.Fragments.desktop";
          "application/x-ms-dos-executable" = "wine.desktop";
          "application/x-shellscript" = "codium.desktop";
          "application/x-wine-extension-ini" = "codium.desktop";
          "application/zip" = "org.gnome.FileRoller.desktop";
          "image/avif" = "org.gnome.gThumb.desktop";
          "image/jpeg" = "org.gnome.gThumb.desktop";
          "image/png" = "org.gnome.gThumb.desktop";
          "image/svg+xml" = "org.gnome.gThumb.desktop";
          "text/html" = "firefox.desktop";
          "text/plain" = "codium.desktop";
          "video/mp4" = "mpv.desktop";
          "video/x-matroska" = "mpv.desktop";
          "x-scheme-handler/about" = "firefox.desktop";
          "x-scheme-handler/http" = "firefox.desktop";
          "x-scheme-handler/https" = "firefox.desktop";
          "x-scheme-handler/unknown" = "firefox.desktop";
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
