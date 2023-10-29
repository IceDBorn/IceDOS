{ lib, config, pkgs, ... }:
let
  swayidleconf = pkgs.writeShellScriptBin "swayidleconf" ''
    swayidle -w timeout 180 'swaylockconf' \
            timeout 300 'hyprctl dispatch dpms off'  \
            resume 'hyprctl dispatch dpms on' \
            timeout 900 'systemctl suspend' \
            before-sleep 'swaylockconf' &
  '';

  swaylockconf = pkgs.writeShellScriptBin "swaylockconf" ''
    swaylock --daemonize \
    --clock \
    --indicator-idle-visible \
    --fade-in 4 \
    --grace 5 \
    --screenshots \
    --effect-blur 10x10 \
    --inside-color 00000000 \
    --text-color F \
    --ring-color F \
    --effect-vignette 0.2:0.2
  '';
in {
  imports = [
    # Setup home manager for hyprland
    ./home/main.nix
    ./home/work.nix
    # Setup hyprland configs
    ./configs/config.nix
    ./configs/waybar/config.nix
  ];

  programs.hyprland = lib.mkIf config.desktop.hyprland.enable {
    enable = true;
    enableNvidiaPatches = config.hardware.gpu.nvidia.enable;
  };

  environment = lib.mkIf config.desktop.hyprland.enable {
    systemPackages = with pkgs; [
      clipman # Clipboard manager for wayland
      gnome.gnome-calendar # Calendar
      grimblast # Screenshot tool
      hyprland-per-window-layout # Per window layout
      hyprpaper # Wallpaper daemon
      rofi-wayland # App launcher
      slurp # Monitor selector
      swayidle # Idle inhibitor
      swayidleconf # Configure swayidle
      swaylock-effects # Lock
      swaylockconf # Configure swaylock
      waybar # Status bar
      wdisplays # Displays manager
      wl-clipboard # Clipboard daemon
      wlogout # Logout screen
    ];

    etc = lib.mkIf config.desktop.hyprland.enable {
      "wlogout-icons".source = "${pkgs.wlogout}/share/wlogout/icons";
    };
  };

  # Needed for hyprland flake
  disabledModules = [ "programs/hyprland.nix" ];

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
