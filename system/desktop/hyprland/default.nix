{ pkgs, config, lib, inputs, ... }:

let
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

  swaylock-wrapper = import modules/swaylock-wrapper.nix { pkgs = pkgs; };

  cfg = config.desktop.hyprland;
in {
  imports = [
    ./configs/config.nix
    ./configs/hypridle.nix
    ./configs/swaync/config.nix
    ./configs/waybar/config.nix
    ./home.nix
  ];

  programs = lib.mkIf (cfg.enable) {
    nm-applet.enable = true; # Network manager tray icon
    kdeconnect.enable = true; # Connect phone to PC
    hyprland.enable = true;
  };

  environment = lib.mkIf (cfg.enable) {
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
      swaylock-effects # Lock
      swaylock-wrapper # Wrap swaylock
      swaynotificationcenter # Notification daemon
      swayosd # Notifications for volume, caps lock etc.
      sysstat # Needed for disk-watcher
      waybar # Status bar
      wdisplays # Displays manager
      wl-clipboard # Clipboard daemon
      wlogout # Logout screen
    ];

    etc = lib.mkIf (cfg.enable) {
      "polkit-gnome".source =
        "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      "kdeconnectd".source =
        "${pkgs.libsForQt5.kdeconnect-kde}/libexec/kdeconnectd";
      "wlogout-icons".source = "${pkgs.wlogout}/share/wlogout/icons";
    };
  };

  services = lib.mkIf (cfg.enable) {
    dbus.enable = true;
    gvfs.enable = true; # Needed for nautilus
    gnome.gnome-keyring.enable = true;
  };

  security = lib.mkIf (cfg.enable) {
    polkit.enable = true;
    pam.services.login.enableGnomeKeyring = true;

    # Needed for unlocking to work
    pam.services.swaylock.text = ''
      # Account management.
      account required pam_unix.so

      # Authentication management.
      auth sufficient pam_unix.so   likeauth try_first_pass
      auth required pam_deny.so

      # Password management.
      password sufficient pam_unix.so nullok sha512

      # Session management.
      session required pam_env.so conffile=/etc/pam/environment readenv=0
      session required pam_unix.so
    '';
  };

  systemd.services.swayosd-input = lib.mkIf (cfg.enable) {
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
    lib.mkIf (!config.desktop.gnome.enable && cfg.enable)
    [ pkgs.xdg-desktop-portal-gtk ]; # Needed for steam file picker

  nix.settings = lib.mkIf (cfg.enable) {
    substituters = [ "https://hyprland.cachix.org" ];
    trusted-public-keys =
      [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
  };
}
