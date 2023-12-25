{ lib, config, pkgs, inputs, ... }:
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

  swayidle-wrapper = import modules/swayidle-wrapper.nix {
    pkgs = pkgs;
    config = config;
  };

  swaylock-wrapper = import modules/swaylock-wrapper.nix { pkgs = pkgs; };
in {
  imports = [
    # Setup home manager for hyprland
    ./home/main.nix
    ./home/work.nix
    # Setup hyprland configs
    ./configs/config.nix
    ./configs/waybar/config.nix
  ];

  programs.hyprland.enable = config.desktop.hyprland.enable;

  environment = lib.mkIf config.desktop.hyprland.enable {
    systemPackages = with pkgs; [
      clipman # Clipboard manager for wayland
      cpu-watcher # Script to check if cpu has a usage above given number
      disk-watcher # Script to check if any disk has a read/write usage above given numbers
      gnome.gnome-calendar # Calendar
      grimblast # Screenshot tool
      hyprland-per-window-layout # Per window layout
      hyprpaper # Wallpaper daemon
      hyprpicker # Color picker
      inputs.hycov.packages.${pkgs.system}.hycov # Alt tab functionality
      network-watcher # Script to check if network has a usage above given number
      pipewire-watcher # Script to check if pipewire has active links
      rofi-wayland # App launcher
      slurp # Monitor selector
      swayidle # Idle inhibitor
      swayidle-wrapper # Wrap swayidle
      swaylock-effects # Lock
      swaylock-wrapper # Wrap swaylock
      swayosd # Notifications for volume, caps lock etc.
      sysstat # Needed for disk-watcher
      waybar # Status bar
      wdisplays # Displays manager
      wl-clipboard # Clipboard daemon
      wlogout # Logout screen
    ];

    etc = lib.mkIf config.desktop.hyprland.enable {
      "wlogout-icons".source = "${pkgs.wlogout}/share/wlogout/icons";
    };
  };

  systemd.services.swayosd-input = {
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

  # Needed for unlocking to work
  security.pam.services.swaylock.text = ''
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

  nix.settings = {
    substituters = [ "https://hyprland.cachix.org" ];
    trusted-public-keys =
      [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
  };
}
