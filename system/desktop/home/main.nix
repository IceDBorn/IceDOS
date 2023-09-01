{ config, pkgs, lib, ... }:

lib.mkIf config.main.user.enable {
  home-manager.users.${config.main.user.username} = {
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
      desktopEntries = {
        discord = {
          name = "Discord";
          exec =
            "discord --enable-features=UseOzonePlatform --ozone-platform=wayland";
          icon = "discord";
        }; # Force discord to use wayland

        mullvad-gui = {
          name = "Mullvad";
          exec =
            "mullvad-gui --enable-features=UseOzonePlatform,WaylandWindowDecorations --ozone-platform=wayland";
          icon = "mullvad-vpn";
        }; # Force mullvad to use wayland and window decorations
      };

      mimeApps = {
        enable = true;

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
          "x-scheme-handler/http" = "firefox.desktop";
          "x-scheme-handler/https" = "firefox.desktop";
          "x-scheme-handler/about" = "firefox.desktop";
          "x-scheme-handler/unknown" = "firefox.desktop";
        };
      }; # Default apps
    };

    home.file = {
      # New document options for nautilus
      "Templates/new" = {
        text = "";
        recursive = true;
      };

      "Templates/new.cfg" = {
        text = "";
        recursive = true;
      };

      "Templates/new.ini" = {
        text = "";
        recursive = true;
      };

      "Templates/new.sh" = {
        text = "";
        recursive = true;
      };

      "Templates/new.txt" = {
        text = "";
        recursive = true;
      };

      ".icons/default" = {
        source = "${pkgs.bibata-cursors}/share/icons/Bibata-Modern-Classic";
        recursive = true;
      }; # Set icon theme fot QT apps and Hyprland
    };
  };
}
