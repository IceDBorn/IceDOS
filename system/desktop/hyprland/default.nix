{ pkgs, config, lib, inputs, ... }:

let
  inherit (lib) mkIf;

  cfg = config.icedos;

  cpu-watcher = import modules/cpu-watcher.nix {
    pkgs = pkgs;
    config = config;
  };

  disk-watcher = import modules/disk-watcher.nix {
    pkgs = pkgs;
    config = config;
  };

  network-watcher = import modules/network-watcher.nix {
    pkgs = pkgs;
    config = config;
  };

  pipewire-watcher = import modules/pipewire-watcher.nix { pkgs = pkgs; };

  hyprlock-wrapper = import modules/hyprlock-wrapper.nix { pkgs = pkgs; };

in {
  imports = [
    ./configs/config.nix
    ./configs/hypridle.nix
    ./configs/swaync/config.nix
    ./configs/waybar/config.nix
    ./home.nix
  ];

  programs = mkIf (cfg.desktop.hyprland.enable) {
    nm-applet.enable = true; # Network manager tray icon
    kdeconnect.enable = true; # Connect phone to PC
    hyprland.enable = true;
  };

  environment = mkIf (cfg.desktop.hyprland.enable) {
    systemPackages = with pkgs; [
      baobab # Disk usage analyser
      brightnessctl # Brightness control
      cliphist # Clipboard manager for wayland
      cliphist-rofi-img # Image support for cliphist
      cpu-watcher # Script to check if cpu has a usage above given number
      disk-watcher # Script to check if any disk has a read/write usage above given numbers
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
      hyprlock-wrapper # Wrap hyprlock
      hyprpaper # Wallpaper daemon
      hyprpicker # Color picker
      inputs.hycov.packages.${pkgs.system}.hycov # Alt tab functionality
      network-watcher # Script to check if network has a usage above given number
      networkmanagerapplet # Network manager tray icon
      overskride # Bluetooth manager
      pipewire-watcher # Script to check if pipewire has active links
      polkit_gnome # Polkit manager
      rofi-wayland # App launcher
      rofi-wayland # App launcher
      slurp # Monitor selector
      swappy # Edit screenshots
      swaynotificationcenter # Notification daemon
      swayosd # Notifications for volume, caps lock etc.
      sysstat # Needed for disk-watcher
      waybar # Status bar
      wdisplays # Displays manager
      wl-clipboard # Clipboard daemon
      wlogout # Logout screen
    ];

    etc = mkIf (cfg.desktop.hyprland.enable) {
      "polkit-gnome".source =
        "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      "kdeconnectd".source =
        "${pkgs.libsForQt5.kdeconnect-kde}/libexec/kdeconnectd";
      "wlogout-icons".source = "${pkgs.wlogout}/share/wlogout/icons";
    };
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
    description =
      "SwayOSD LibInput backend for listening to certain keys like CapsLock, ScrollLock, VolumeUp, etc...";
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

  xdg.portal.extraPortals =
    mkIf (!cfg.desktop.gnome.enable && cfg.desktop.hyprland.enable)
    [ pkgs.xdg-desktop-portal-gtk ]; # Needed for steam file picker

  nix.settings = mkIf (cfg.desktop.hyprland.enable) {
    substituters = [ "https://hyprland.cachix.org" ];
    trusted-public-keys =
      [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
  };
}
