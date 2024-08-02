{
  pkgs,
  config,
  lib,
  ...
}:

let
  inherit (lib) mkIf;

  cfg = config.icedos;
in
{
  imports = [
    ../applications/modules/nautilus.nix
    ../applications/modules/pipewire.nix
    ./home.nix # Setup home manager
  ];

  # Set your time zone
  time.timeZone = "Europe/Bucharest";

  # Set your locale settings
  i18n = {
    defaultLocale = "en_US.utf8";
    extraLocaleSettings.LC_MEASUREMENT = "es_ES.utf8";
  };

  services = {
    displayManager.autoLogin =
      mkIf (cfg.desktop.autologin.enable && !cfg.applications.steam.session.autoStart.enable)
        {
          enable = true;
          user = cfg.desktop.autologin.user;
        };

    xserver = mkIf (!cfg.applications.steam.session.autoStart.enable) {
      # Enable the X11 windowing system
      enable = true;

      displayManager.gdm = mkIf (cfg.desktop.gdm.enable) {
        enable = true;
        autoSuspend = cfg.desktop.gdm.autoSuspend;
      };

      xkb.layout = "us,gr";
    };
  };

  # Workaround for GDM autologin
  systemd.services = {
    "getty@tty1".enable = false;
    "autovt@tty1".enable = false;
  };

  networking = {
    networkmanager.enable = !cfg.hardware.devices.server.enable;
    firewall.enable = false;
  };

  security.sudo.extraConfig = "Defaults pwfeedback"; # Show asterisks when typing sudo password

  environment = {
    # Packages to install for all window manager/desktop environments
    systemPackages = with pkgs; [
      adwaita-icon-theme # GTK theme
      bibata-cursors # Material cursors
      dconf-editor # Edit gnome's dconf
      libnotify # Send desktop notifications
      tela-icon-theme # Icon theme
    ];
  };

  fonts.packages = with pkgs; [
    meslo-lgs-nf
    cantarell-fonts
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
  ];

  # Use the first portal implementation found in lexicographical order
  xdg.portal.config.common.default = "*";
}
