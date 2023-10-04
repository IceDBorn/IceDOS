{ config, pkgs, lib, ... }:

lib.mkIf config.system.user.work.enable {
  home-manager.users.${config.system.user.work.username} = {
    programs = {
      git = {
        enable = true;
        # Git config
        userName = "${config.system.user.work.git.username}";
        userEmail = "${config.system.user.work.git.email}";
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
      ".config/zsh/zsh-theme.zsh" = { source = ../configs/zsh-theme.zsh; };

      # Add update-codium-extensions to zsh directory
      ".config/zsh/update-codium-extensions.sh".source =
        ../../scripts/update-codium-extensions.sh;

      # Add vscodium config
      ".config/VSCodium/User/settings.json".source = ../configs/vscodium.json;

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

      # Add tmux config
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
