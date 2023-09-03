{ config, pkgs, lib, ... }:

lib.mkIf config.main.user.enable {
  home-manager.users.${config.main.user.username} = {
    programs = {
      git = {
        enable = true;
        # Git config
        userName = "${config.main.user.github.username}";
        userEmail = "${config.main.user.github.email}";
      };

      kitty = {
        enable = true;
        settings = {
          background_opacity = "0.8";
          confirm_os_window_close = "0";
          cursor_shape = "beam";
          enable_audio_bell = "no";
          hide_window_decorations = "yes";
          update_check_interval = "0";
          copy_on_select = "no";
        };
        font.name = "JetBrainsMono Nerd Font";
        font.size = 10;
        theme = "Catppuccin-Mocha";
      };

      mangohud = {
        enable = true;
        # Mangohud config
        settings = {
          background_alpha = 0;
          cpu_color = "FFFFFF";
          cpu_temp = true;
          engine_color = "FFFFFF";
          font_size = 20;
          fps = true;
          fps_limit = "144+60+0";
          frame_timing = 0;
          gamemode = true;
          gl_vsync = 0;
          gpu_color = "FFFFFF";
          gpu_temp = true;
          no_small_font = true;
          offset_x = 50;
          position = "top-right";
          toggle_fps_limit = "Ctrl_L+Shift_L+F1";
          vsync = 1;
        };
      };

      zsh = {
        enable = true;
        # Enable firefox wayland
        profileExtra = "export MOZ_ENABLE_WAYLAND=1";

        # Install powerlevel10k
        plugins = with pkgs; [
          {
            name = "powerlevel10k";
            src = zsh-powerlevel10k;
            file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
          }
          {
            name = "zsh-nix-shell";
            file = "share/zsh-nix-shell/nix-shell.plugin.zsh";
            src = zsh-nix-shell;
          }
        ];
      };

      # Install gnome extensions using firefox
      firefox.enableGnomeExtensions = true;
    };

    home.file = {
      # Add zsh theme to zsh directory
      ".config/zsh/zsh-theme.zsh" = {
        source = ../configs/zsh-theme.zsh;
        recursive = true;
      };

      # Add proton-ge-updater script to zsh directory
      ".config/zsh/proton-ge-updater.sh" = {
        source = ../../scripts/proton-ge-updater.sh;
        recursive = true;
      };

      # Add steam-library-patcher to zsh directory
      ".config/zsh/steam-library-patcher.sh" = {
        source = ../../scripts/steam-library-patcher.sh;
        recursive = true;
      };

      # Add update-codium-extensions to zsh directory
      ".config/zsh/update-codium-extensions.sh" = {
        source = ../../scripts/update-codium-extensions.sh;
        recursive = true;
      };

      ".config/VSCodium/User/settings.json" = {
        source = ../configs/vscodium.json;
      }; # Add vscodium config

      # Set firefox to privacy profile
      ".mozilla/firefox/profiles.ini" = {
        source = ../configs/firefox/profiles.ini;
        recursive = true;
      };

      # Add user.js
      ".mozilla/firefox/privacy/user.js" = {
        source = if (config.firefox.privacy.enable) then
          "${(pkgs.callPackage ../self-built/arkenfox-userjs.nix { })}/user.js"
        else
          ../configs/firefox/user.js;
        recursive = true;
      };

      # Install firefox gnome theme
      ".mozilla/firefox/privacy/chrome/firefox-gnome-theme" =
        lib.mkIf config.firefox.gnome-theme.enable {
          source = pkgs.callPackage ../self-built/firefox-gnome-theme.nix { };
          recursive = true;
        };

      # Import firefox gnome theme userChrome.css or disable WebRTC indicator
      ".mozilla/firefox/privacy/chrome/userChrome.css" = {
        text = if config.firefox.gnome-theme.enable then
          ''@import "firefox-gnome-theme/userChrome.css"''
        else
          "#webrtcIndicator { display: none }";
        recursive = true;
      };

      # Import firefox gnome theme userContent.css
      ".mozilla/firefox/privacy/chrome/userContent.css" =
        lib.mkIf config.firefox.gnome-theme.enable {
          text = ''@import "firefox-gnome-theme/userContent.css"'';
          recursive = true;
        };

      # Create second firefox profile for pwas
      ".mozilla/firefox/pwas/user.js" = {
        source =
          "${(pkgs.callPackage ../self-built/arkenfox-userjs.nix { })}/user.js";
        recursive = true;
      };

      ".mozilla/firefox/pwas/chrome" = {
        source = pkgs.callPackage ../self-built/firefox-cascade.nix { };
        recursive = true;
      };

      # Add noise suppression microphone
      ".config/pipewire/pipewire.conf.d/99-input-denoising.conf" = {
        source = ../configs/pipewire.conf;
        recursive = true;
      };

      # Add btop config
      ".config/btop/btop.conf" = {
        source = ../configs/btop.conf;
        recursive = true;
      };

      # Add adwaita steam skin
      ".local/share/Steam/steamui" = {
        source =
          "${(pkgs.callPackage ../self-built/adwaita-for-steam { })}/build";
        recursive = true;
      };

      # Enable steam beta
      ".local/share/Steam/package/beta" =
        lib.mkIf config.desktop-environment.steam.beta.enable {
          text = "publicbeta";
          recursive = true;
        };

      # Add custom mangohud config for CS:GO
      ".config/MangoHud/csgo_linux64.conf" = {
        text = ''
          background_alpha=0
          cpu_color=FFFFFF
          cpu_temp
          engine_color=FFFFFF
          font_size=20
          fps
          fps_limit=0+144
          frame_timing=0
          gamemode
          gl_vsync=0
          gpu_color=FFFFFF
          gpu_temp
          no_small_font
          offset_x=50
          position=top-right
          toggle_fps_limit=Ctrl_L+Shift_L+F1
          vsync=1
        '';
        recursive = true;
      };

      # Add custom mangohud config for CS2
      ".config/MangoHud/wine-cs2.conf" = {
        text = ''
          background_alpha=0
          cpu_color=FFFFFF
          cpu_temp
          engine_color=FFFFFF
          font_size=20
          fps
          fps_limit=0+144
          frame_timing=0
          gamemode
          gl_vsync=0
          gpu_color=FFFFFF
          gpu_temp
          no_small_font
          offset_x=50
          position=top-right
          toggle_fps_limit=Ctrl_L+Shift_L+F1
          vsync=1
        '';
        recursive = true;
      };

      # Add nvchad
      ".config/nvim" = {
        source = "${(pkgs.callPackage ../self-built/nvchad.nix { })}";
        recursive = true;
      };

      ".config/nvim/lua/custom" = {
        source = ../configs/nvchad;
        recursive = true;
        force = true;
      };

      # Add tmux
      ".config/tmux/tmux.conf" = {
        source = ../configs/tmux.conf;
        recursive = true;
      };

      ".config/tmux/tpm" = {
        source = "${(pkgs.callPackage ../self-built/tpm.nix { })}";
        recursive = true;
      };

      # Add mpv
      ".config/mpv" = {
        source = ../configs/mpv;
        recursive = true;
      };

      ".bashrc" = {
        text = "";
        recursive = true;
      }; # Avoid file not found errors for bash
    };
  };
}
