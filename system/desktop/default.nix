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
    ../applications/modules/adwaita-qt
    ../applications/modules/nautilus
    ../applications/modules/pipewire
    ./home.nix
  ];

  time.timeZone = "Europe/Bucharest";

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
  };

  networking = {
    networkmanager.enable = !cfg.hardware.devices.server.enable;
    firewall.enable = false;
  };

  environment = {
    # Packages to install for all window manager/desktop environments
    systemPackages = with pkgs; [
      adwaita-icon-theme # Gtk theme
      amberol # Music player
      dconf-editor # Edit gnome's dconf
      libnotify # Send desktop notifications
      loupe # Image viewer
      onlyoffice-bin # Office tools
    ];

    sessionVariables = {
      NIXOS_OZONE_WL = 1;
      QT_QPA_PLATFORM = "wayland;xcb";
      QT_QPA_PLATFORMTHEME = "qt5ct";
    };
  };

  fonts.packages = with pkgs; [
    cantarell-fonts
    meslo-lgs-nf
    nerd-fonts.jetbrains-mono
  ];

  xdg.portal.config.common.default = "*";
}
