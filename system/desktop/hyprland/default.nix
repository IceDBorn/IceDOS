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
    ../../applications/modules/hypridle.nix
    ../../applications/modules/hyprlock
    ../../applications/modules/rofi
    ../../applications/modules/swaync
    ../../applications/modules/swayosd.nix
    ../../applications/modules/valent.nix
    ../../applications/modules/waybar
    ../../applications/modules/wleave
    ./configs/config.nix
    ./home.nix
  ];

  programs = {
    nm-applet.enable = true; # Network manager tray icon
    hyprland.enable = true;
  };

  environment = {
    systemPackages = with pkgs; [
      baobab # Disk usage analyser
      brightnessctl # Brightness control
      cliphist # Clipboard manager for wayland
      feh # Minimal image viewer
      file-roller # Archive file manager
      gnome-calculator # Calculator
      gnome-calendar # Calendar
      gnome-clocks # Clock
      gnome-control-center # Gnome settings
      gnome-disk-utility # Disks manager
      gnome-keyring # Keyring daemon
      gnome-online-accounts # Nextcloud integration
      gnome-themes-extra # Adwaita GTK theme
      grim # Screenshot tool
      grimblast # Screenshot tool
      hyprfreeze # Script to freeze active hyprland window
      hyprland-per-window-layout # Per window layout
      hyprland-startup # Startup script
      hyprpaper # Wallpaper daemon
      hyprpicker # Color picker
      hyprpolkitagent # Polkit manager
      hyprshade # Shader config tool
      playerctl # MPRIS cli
      poweralertd # Battery level alerts
      slurp # Monitor selector
      swappy # Edit screenshots
      sysstat # Needed for disk-watcher
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
