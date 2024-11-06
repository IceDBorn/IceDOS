{
  config,
  pkgs,
  ...
}:

let
  cpu-watcher = import modules/cpu-watcher.nix { inherit pkgs config; };
  disk-watcher = import modules/disk-watcher.nix { inherit pkgs config; };

  hyprland-startup = import ../../applications/modules/hyprland-startup.nix {
    inherit config pkgs;
  };

  network-watcher = import modules/network-watcher.nix { inherit pkgs config; };
  pipewire-watcher = import modules/pipewire-watcher.nix { inherit pkgs; };

  shellScripts = [
    cpu-watcher # Script to check if cpu has a usage above given number
    disk-watcher # Script to check if any disk has a read/write usage above given numbers
    hyprland-startup # Startup script
    network-watcher # Script to check if network has a usage above given number
    pipewire-watcher # Script to check if pipewire has active links
  ];
in
{
  imports = [
    ../../applications/modules/hypridle.nix
    ../../applications/modules/hyprlock
    ../../applications/modules/swaync
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
    systemPackages =
      with pkgs;
      [
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
        hyprpaper # Wallpaper daemon
        hyprpicker # Color picker
        hyprpolkitagent # Polkit manager
        hyprshade # Shader config tool
        networkmanagerapplet # Network manager tray icon
        poweralertd # Battery level alerts
        rofi-wayland # App launcher
        slurp # Monitor selector
        swappy # Edit screenshots
        swayosd # Notifications for volume, caps lock etc.
        sysstat # Needed for disk-watcher
        wdisplays # Displays manager
        wl-clipboard # Clipboard daemon
      ]
      ++ shellScripts;
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

  systemd.services.swayosd-input = {
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

  nix.settings = {
    substituters = [ "https://hyprland.cachix.org" ];
    trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
  };

  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
}
