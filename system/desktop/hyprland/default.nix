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
    ../../applications/modules/gnome-control-center
    ../../applications/modules/hypridle
    ../../applications/modules/hyprlock
    ../../applications/modules/hyprpaper
    ../../applications/modules/nwg
    ../../applications/modules/swaync
    ../../applications/modules/swayosd
    ../../applications/modules/valent
    ../../applications/modules/walker
    ../../applications/modules/wleave
    ./config.nix
  ];

  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };

  environment = {
    systemPackages = with pkgs; [
      baobab # Disk usage analyser
      file-roller # Archive file manager
      gnome-calculator # Calculator
      gnome-disk-utility # Disks manager
      gnome-keyring # Keyring daemon
      gnome-online-accounts # Nextcloud integration
      gnome-themes-extra # Adwaita GTK theme
      grimblast # Screenshot tool
      hyprfreeze # Script to freeze active hyprland window
      hyprland-per-window-layout # Per window layout
      hyprland-startup # Startup script
      hyprpicker # Color picker
      hyprpolkitagent # Polkit manager
      hyprshade # Shader config tool
      networkmanagerapplet # Network manager app and tray icon
      poweralertd # Battery level alerts
      slurp # Monitor selector
      swappy # Edit screenshots
      wdisplays # Displays manager
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

  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
}
