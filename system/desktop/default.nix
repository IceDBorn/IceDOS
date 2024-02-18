# ## DESKTOP POWERED BY GNOME ###
{ pkgs, config, lib, ... }: {
  imports = [ ./home.nix ]; # Setup home manager

  # Set your time zone
  time.timeZone = "Europe/Bucharest";

  # Set your locale settings
  i18n = {
    defaultLocale = "en_US.utf8";
    extraLocaleSettings.LC_MEASUREMENT = "es_ES.utf8";
  };

  services = {
    xserver = {
      enable = true; # Enable the X11 windowing system

      displayManager = {
        gdm = {
          enable = config.desktop.gdm.enable;
          autoSuspend = config.desktop.gdm.autoSuspend;
        };

        autoLogin = lib.mkIf config.desktop.autologin.enable {
          enable = true;
          user = if (config.system.user.main.enable
            && config.desktop.autologin.main.user.enable) then
            config.system.user.main.username
          else if (config.system.user.work.enable) then
            config.system.user.work.username
          else
            "";
        };
      };

      xkb.layout = "us,gr";
    };

    # Enable sound with pipewire
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
  };

  # Workaround for GDM autologin
  systemd.services = {
    "getty@tty1".enable = false;
    "autovt@tty1".enable = false;
  };

  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable =
    true; # Enable service which hands out realtime scheduling priority to user processes on demand, required by pipewire

  networking = {
    networkmanager.enable = true;
    firewall.enable = false;
  };

  security.sudo.extraConfig =
    "Defaults pwfeedback"; # Show asterisks when typing sudo password

  environment = {
    # Packages to install for all window manager/desktop environments
    systemPackages = with pkgs; [
      bibata-cursors # Material cursors
      gnome.adwaita-icon-theme # GTK theme
      tela-icon-theme # Icon theme
    ];

    sessionVariables = {
      # Set Firefox as default browser for Electron apps
      DEFAULT_BROWSER = "${pkgs.firefox}/bin/firefox";
      # Fix nautilus not displaying audio/video information in properties https://github.com/NixOS/nixpkgs/issues/53631
      GST_PLUGIN_SYSTEM_PATH_1_0 =
        lib.makeSearchPathOutput "lib" "lib/gstreamer-1.0"
        (with pkgs.gst_all_1; [
          gst-plugins-good
          gst-plugins-bad
          gst-plugins-ugly
          gst-libav
        ]); # Fix from https://github.com/NixOS/nixpkgs/issues/195936#issuecomment-1366902737
    };
  };

  fonts.packages = with pkgs; [
    meslo-lgs-nf
    cantarell-fonts
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
  ];

  # Use the first portal implementation found in lexicographical order
  xdg.portal.config.common.default = "*";
}
