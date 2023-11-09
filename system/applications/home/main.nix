{ config, pkgs, lib, ... }:

lib.mkIf config.system.user.main.enable {
  home-manager.users.${config.system.user.main.username} = {
    programs = {
      git = {
        enable = true;
        # Git config
        extraConfig = { pull.rebase = true; };
        userName = "${config.system.user.main.git.username}";
        userEmail = "${config.system.user.main.git.email}";
      };

      kitty = {
        enable = true;
        settings = {
          background_opacity = "0.8";
          confirm_os_window_close = "0";
          cursor_shape = "beam";
          enable_audio_bell = "no";
          hide_window_decorations =
            if (config.applications.kitty.hide-decorations) then
              "yes"
            else
              "no";
          update_check_interval = "0";
          copy_on_select = "no";
          wayland_titlebar_color = "background";
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
          battery = config.hardware.laptop.enable;
          battery_icon = config.hardware.laptop.enable;
          battery_time = config.hardware.laptop.enable;
          cpu_color = "FFFFFF";
          cpu_power = true;
          cpu_temp = true;
          engine_color = "FFFFFF";
          engine_short_names = true;
          font_size = 18;
          fps_color = "FFFFFF";
          fps_limit = "${config.hardware.monitors.main.refresh-rate},60,0";
          frame_timing = false;
          frametime = false;
          gl_vsync = 0;
          gpu_color = "FFFFFF";
          gpu_power = true;
          gpu_temp = true;
          horizontal = true;
          hud_compact = true;
          hud_no_margin = true;
          no_small_font = true;
          offset_x = 5;
          offset_y = 5;
          text_color = "FFFFFF";
          toggle_fps_limit = "Ctrl_L+Shift_L+F1";
          vram_color = "FFFFFF";
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
      ".config/zsh/zsh-theme.zsh".source = ../configs/zsh-theme.zsh;

      # Add proton-ge-updater script to zsh directory
      ".config/zsh/proton-ge-updater.sh".source =
        ../../scripts/proton-ge-updater.sh;

      # Add steam-library-patcher to zsh directory
      ".config/zsh/steam-library-patcher.sh".source =
        ../../scripts/steam-library-patcher.sh;

      # Add update-codium-extensions to zsh directory
      ".config/zsh/update-codium-extensions.sh".source =
        ../../scripts/update-codium-extensions.sh;

      # Add vscodium config
      ".config/VSCodium/User/settings.json".source = ../configs/vscodium.json;

      # Set firefox to privacy profile
      ".mozilla/firefox/profiles.ini".source = ../configs/firefox/profiles.ini;

      # Add user.js
      ".mozilla/firefox/privacy/user.js".source =
        if (config.applications.firefox.privacy.enable) then
          "${(pkgs.callPackage ../self-built/arkenfox-userjs.nix { })}/user.js"
        else
          ../configs/firefox/user.js;

      # Install firefox gnome theme
      ".mozilla/firefox/privacy/chrome/firefox-gnome-theme" =
        lib.mkIf config.applications.firefox.gnome-theme.enable {
          source = pkgs.callPackage ../self-built/firefox-gnome-theme.nix { };
          recursive = true;
        };

      # Import firefox gnome theme userChrome.css or disable WebRTC indicator
      ".mozilla/firefox/privacy/chrome/userChrome.css".text =
        if config.applications.firefox.gnome-theme.enable then
          ''@import "firefox-gnome-theme/userChrome.css"''
        else
          "#webrtcIndicator { display: none }";

      # Import firefox gnome theme userContent.css
      ".mozilla/firefox/privacy/chrome/userContent.css".text =
        lib.mkIf config.applications.firefox.gnome-theme.enable
        ''@import "firefox-gnome-theme/userContent.css"'';

      # Create second firefox profile for pwas
      ".mozilla/firefox/pwas/user.js".source =
        "${(pkgs.callPackage ../self-built/arkenfox-userjs.nix { })}/user.js";

      ".mozilla/firefox/pwas/chrome" = {
        source = pkgs.callPackage ../self-built/firefox-cascade.nix { };
        recursive = true;
      };

      # Add noise suppression microphone
      ".config/pipewire/pipewire.conf.d/99-input-denoising.conf".source =
        ../configs/pipewire.conf;

      # Add btop config
      ".config/btop/btop.conf".source = ../configs/btop.conf;

      # Add adwaita steam skin
      ".local/share/Steam/steamui" = {
        source = "${
            (pkgs.callPackage ../self-built/adwaita-for-steam {
              config = config;
            })
          }/build";
        recursive = true;
      };

      # Enable steam beta
      ".local/share/Steam/package/beta" =
        lib.mkIf (config.applications.steam.beta.enable) {
          text = if (config.applications.steam.session.enable) then
            "steamdeck_publicbeta"
          else
            "publicbeta";
        };

      # Enable slow steam downloads workaround
      ".local/share/Steam/steam_dev.cfg".text =
        lib.mkIf config.applications.steam.downloads-workaround.enable ''
          @nClientDownloadEnableHTTP2PlatformLinux 0
          @fDownloadRateImprovementToAddAnotherConnection 1.0
        '';

      # Add nvchad
      ".config/nvim" = {
        source = "${(pkgs.callPackage ../self-built/nvchad.nix { })}";
        recursive = true;
      };

      ".config/nvim/lua/custom/configs" = {
        source = ../configs/nvchad/configs;
        recursive = true;
      };

      ".config/nvim/lua/custom/chadrc.lua".source =
        ../configs/nvchad/chadrc.lua;
      ".config/nvim/lua/custom/mappings.lua".source =
        ../configs/nvchad/mappings.lua;
      ".config/nvim/lua/custom/plugins.lua".source =
        ../configs/nvchad/plugins.lua;
      ".config/nvim/lua/custom/init.lua".text =
        config.applications.nvchad.initLua;

      # Add tmux
      ".config/tmux/tmux.conf".source = ../configs/tmux.conf;

      ".config/tmux/tpm" = {
        source = "${(pkgs.callPackage ../self-built/tpm.nix { })}";
        recursive = true;
      };

      # Add mpv
      ".config/mpv" = {
        source = ../configs/mpv;
        recursive = true;
      };

      # Avoid file not found errors for bash
      ".bashrc".text = "";
    };
  };
}
