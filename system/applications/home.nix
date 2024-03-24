{ config, pkgs, lib, ... }:

let
  inherit (lib) attrNames filter foldl' mkIf;

  cfg = config.icedos;

  mapAttrsAndKeys = callback: list:
    (foldl' (acc: value: acc // (callback value)) { } list);
in {
  home-manager.users = let
    users = filter (user: cfg.system.user.${user}.enable == true)
      (attrNames cfg.system.user);
  in mapAttrsAndKeys (user:
    let username = cfg.system.user.${user}.username;
    in {
      ${username} = {
        programs = {
          git = {
            enable = true;
            # Git config
            extraConfig = { pull.rebase = true; };
            userName = "${cfg.system.user.${user}.git.username}";
            userEmail = "${cfg.system.user.${user}.git.email}";
          };

          kitty = {
            enable = true;
            settings = {
              background_opacity = "0.8";
              confirm_os_window_close = "0";
              cursor_shape = "beam";
              enable_audio_bell = "no";
              hide_window_decorations =
                if (cfg.applications.kitty.hideDecorations) then
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
              battery = cfg.hardware.laptop.enable;
              battery_icon = cfg.hardware.laptop.enable;
              battery_time = cfg.hardware.laptop.enable;
              cpu_color = "FFFFFF";
              cpu_power = true;
              cpu_temp = true;
              engine_color = "FFFFFF";
              engine_short_names = true;
              font_size = 18;
              fps_color = "FFFFFF";
              fps_limit = "${cfg.hardware.monitors.main.refreshRate},60,0";
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
          ".config/zsh/zsh-theme.zsh".source = configs/zsh-theme.zsh;

          # Add vscodium config
          ".config/VSCodium/User/settings.json".source = configs/vscodium.json;
          ".config/VSCodiumIDE/User/settings.json".source =
            configs/vscodium.json;

          # Set firefox to privacy profile
          ".mozilla/firefox/profiles.ini" = {
            source = configs/firefox/profiles.ini;
            force = true;
          };

          # Install firefox gnome theme
          ".mozilla/firefox/privacy/chrome/firefox-gnome-theme" =
            mkIf (cfg.applications.firefox.gnomeTheme) {
              source = pkgs.firefox-gnome-theme;
              recursive = true;
            };

          # Import firefox gnome theme userChrome.css or disable WebRTC indicator
          ".mozilla/firefox/privacy/chrome/userChrome.css".text =
            if (cfg.applications.firefox.gnomeTheme) then
              ''@import "firefox-gnome-theme/userChrome.css"''
            else
              "#webrtcIndicator { display: none }";

          # Import firefox gnome theme userContent.css
          ".mozilla/firefox/privacy/chrome/userContent.css".text =
            if cfg.applications.firefox.gnomeTheme then
              ''@import "firefox-gnome-theme/userContent.css"''
            else
              "";

          ".mozilla/firefox/pwas/chrome" = {
            source = pkgs.firefox-cascade;
            recursive = true;
          };

          # Add btop config
          ".config/btop/btop.conf".source = configs/btop.conf;

          # Add adwaita steam skin
          ".local/share/Steam/steamui" = mkIf
            (user != "work" && cfg.applications.steam.adwaitaForSteam.enable) {
              source = "${pkgs.adwaita-for-steam}/build";
              recursive = true;
            };

          # Enable steam beta
          ".local/share/Steam/package/beta" =
            mkIf (user != "work" && cfg.applications.steam.beta) {
              text = if (cfg.applications.steam.session.enable) then
                "steamdeck_publicbeta"
              else
                "publicbeta";
            };

          # Enable slow steam downloads workaround
          ".local/share/Steam/steam_dev.cfg" = mkIf
            (user != "work" && cfg.applications.steam.downloadsWorkaround) {
              text = ''
                @nClientDownloadEnableHTTP2PlatformLinux 0
                @fDownloadRateImprovementToAddAnotherConnection 1.0
              '';
            };

          # Add nvchad
          ".config/nvim" = {
            source = pkgs.nvchad;
            recursive = true;
          };

          ".config/nvim/lua/custom/configs" = {
            source = configs/nvchad/configs;
            recursive = true;
          };

          ".config/nvim/lua/custom/chadrc.lua".source =
            configs/nvchad/chadrc.lua;
          ".config/nvim/lua/custom/mappings.lua".source =
            configs/nvchad/mappings.lua;
          ".config/nvim/lua/custom/plugins.lua".source =
            configs/nvchad/plugins.lua;

          # Add tmux
          ".config/tmux/tmux.conf".source = configs/tmux.conf;

          ".config/tmux/tpm" = {
            source = pkgs.tpm;
            recursive = true;
          };

          # Add celluloid config file
          ".config/celluloid" = {
            source = configs/celluloid;
            recursive = true;
          };

          # Avoid file not found errors for bash
          ".bashrc".text = "export EDITOR=nvim";
        };

        # Set celluloid config file path
        dconf.settings = {
          "io/github/celluloid-player/celluloid" = {
            mpv-config-file =
              "file:///home/${username}/.config/celluloid/celluloid.conf";
          };

          "io/github/celluloid-player/celluloid" = {
            mpv-config-enable = true;
          };

          "io/github/celluloid-player/celluloid" = {
            always-append-to-playlist = true;
          };
        };
      };
    }) users;
}
