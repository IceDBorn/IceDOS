{
  pkgs,
  config,
  lib,
  ...
}:

let
  inherit (lib) mkIf;
  cfg = config.icedos;

  cpu-watcher = import modules/cpu-watcher.nix { inherit pkgs config; };
  disk-watcher = import modules/disk-watcher.nix { inherit pkgs config; };

  hyprland-startup = import modules/hyprland-startup.nix { inherit pkgs config; };

  hyprlock-wrapper = import modules/hyprlock-wrapper.nix { inherit pkgs; };
  network-watcher = import modules/network-watcher.nix { inherit pkgs config; };
  pipewire-watcher = import modules/pipewire-watcher.nix { inherit pkgs; };

  shellScripts = [
    cpu-watcher # Script to check if cpu has a usage above given number
    disk-watcher # Script to check if any disk has a read/write usage above given numbers
    hyprland-startup # Startup script
    hyprlock-wrapper # Wrap hyprlock
    pipewire-watcher # Script to check if pipewire has active links
  ];
in
{
  imports = [
    ./configs/config.nix
    ./configs/hypridle.nix
    ./configs/swaync/config.nix
    ./configs/waybar/config.nix
    ./configs/wleave/style.nix
    ./home.nix
  ];

  programs = mkIf (cfg.desktop.hyprland.enable) {
    nm-applet.enable = true; # Network manager tray icon
    kdeconnect.enable = true; # Connect phone to PC
    hyprland.enable = true;
  };

  environment = mkIf (cfg.desktop.hyprland.enable) {
    systemPackages =
      with pkgs;
      [
        baobab # Disk usage analyser
        blueberry # Bluetooth manager
        brightnessctl # Brightness control
        cliphist # Clipboard manager for wayland
        cliphist-rofi-img # Image support for cliphist with rofi
        feh # Minimal image viewer
        gnome-online-accounts # Nextcloud integration
        gnome.file-roller # Archive file manager
        gnome.gnome-calculator # Calculator
        gnome.gnome-calendar # Calendar
        gnome.gnome-clocks # Clock
        gnome.gnome-control-center # Gnome settings
        gnome.gnome-disk-utility # Disks manager
        gnome.gnome-keyring # Keyring daemon
        gnome.gnome-themes-extra # Adwaita GTK theme
        gnome.nautilus # File manager
        grim # Screenshot tool
        grimblast # Screenshot tool
        hyprfreeze # Script to freeze active hyprland window
        hypridle # Idle inhibitor
        hyprland-per-window-layout # Per window layout
        hyprlock # Lock
        hyprpaper # Wallpaper daemon
        hyprpicker # Color picker
        network-watcher # Script to check if network has a usage above given number
        networkmanagerapplet # Network manager tray icon
        polkit_gnome # Polkit manager
        poweralertd # Battery level alerts
        rofi-wayland # App launcher
        slurp # Monitor selector
        swappy # Edit screenshots
        swaynotificationcenter # Notification daemon
        swayosd # Notifications for volume, caps lock etc.
        sysstat # Needed for disk-watcher
        waybar # Status bar
        wdisplays # Displays manager
        wl-clipboard # Clipboard daemon
        wleave # Logout screen
      ]
      ++ shellScripts;
  };

  services = mkIf (cfg.desktop.hyprland.enable) {
    dbus.enable = true;
    gvfs.enable = true; # Needed for nautilus
    gnome.gnome-keyring.enable = true;
  };

  security = mkIf (cfg.desktop.hyprland.enable) {
    polkit.enable = true;
    pam.services.login.enableGnomeKeyring = true;
  };

  systemd.services.swayosd-input = mkIf (cfg.desktop.hyprland.enable) {
    enable = true;
    description = "SwayOSD LibInput backend for listening to certain keys like CapsLock, ScrollLock, VolumeUp, etc...";
    after = [ "graphical.target" ];

    unitConfig = {
      ConditionPathExists = "${pkgs.swayosd}/bin/swayosd-libinput-backend";
      PartOf = [ "graphical.target" ];
    };

    serviceConfig = {
      User = "root";
      Type = "dbus";
      BusName = "org.erikreider.swayosd";
      ExecStart = "${pkgs.swayosd}/bin/swayosd-libinput-backend";
      Restart = "on-failure";
    };

    wantedBy = [ "graphical.target" ];
  };

  xdg.portal.extraPortals = mkIf (!cfg.desktop.gnome.enable && cfg.desktop.hyprland.enable) [
    pkgs.xdg-desktop-portal-gtk
  ]; # Needed for steam file picker

  nix.settings = mkIf (cfg.desktop.hyprland.enable) {
    substituters = [ "https://hyprland.cachix.org" ];
    trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
  };
}
