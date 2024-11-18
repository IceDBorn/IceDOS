{
  config,
  pkgs,
  ...
}:

let
  hyprland-startup = import ../../applications/modules/hyprland-startup.nix {
    inherit config pkgs;
  };
in
{
  imports = [
    ../../applications/modules/gnome-control-center.nix
    ../../applications/modules/hypridle.nix
    ../../applications/modules/hyprlock
    ../../applications/modules/hyprpaper
    ../../applications/modules/swaync
    ../../applications/modules/nwg
    ../../applications/modules/swayosd.nix
    ../../applications/modules/valent.nix
    ../../applications/modules/walker
    ../../applications/modules/wleave
    ./config.nix
  ];

  programs.hyprland.enable = true;

  environment = {
    systemPackages = with pkgs; [
      baobab # Disk usage analyser
      feh # Minimal image viewer
      file-roller # Archive file manager
      gnome-calculator # Calculator
      gnome-disk-utility # Disks manager
      gnome-keyring # Keyring daemon
      gnome-online-accounts # Nextcloud integration
      gnome-themes-extra # Adwaita GTK theme
      grim # Screenshot tool
      grimblast # Screenshot tool
      hyprfreeze # Script to freeze active hyprland window
      hyprland-per-window-layout # Per window layout
      hyprland-startup # Startup script
      hyprpicker # Color picker
      hyprpolkitagent # Polkit manager
      hyprshade # Shader config tool
      networkmanagerapplet # Network manager app and tray icon
      playerctl # MPRIS cli
      poweralertd # Battery level alerts
      slurp # Monitor selector
      swappy # Edit screenshots
      wdisplays # Displays manager
      wl-clipboard # Clipboard daemon
    ];
  };

  services = {
    dbus = {
      enable = true;
      implementation = "broker";
    };

    gnome.gnome-keyring.enable = true;
  };

  security = {
    polkit.enable = true;
    pam.services.login.enableGnomeKeyring = true;
  };

  nix.settings = {
    substituters = [ "https://hyprland.cachix.org" ];
    trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
  };

  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
}
