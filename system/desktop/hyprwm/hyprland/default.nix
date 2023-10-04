{ lib, config, pkgs, ... }:

{
  imports = [
    # Setup home manager for hyprland
    ./home/main.nix
    ./home/work.nix
    # Setup hyprland config
    ./config.nix
  ];

  programs.hyprland = lib.mkIf config.desktop.hyprland.enable {
    enable = true;
    enableNvidiaPatches = config.hardware.gpu.nvidia.enable;
  };

  environment = lib.mkIf config.desktop.hyprland.enable {
    systemPackages = with pkgs; [
      clipman # Clipboard manager for wayland
      hyprland-per-window-layout # Per window layout
      hyprpaper # Wallpaper daemon
      rofi-wayland # App launcher
      slurp # Monitor selector
      waybar # Status bar
      wdisplays # Displays manager
      wl-clipboard # Clipboard daemon
      wlogout # Logout screen
    ];

    etc = lib.mkIf config.desktop.hyprland.enable {
      "wlogout-icons".source = "${pkgs.wlogout}/share/wlogout/icons";
    };
  };

  disabledModules = [ "programs/hyprland.nix" ]; # Needed for hyprland flake

  nix.settings = {
    substituters = [ "https://hyprland.cachix.org" ];
    trusted-public-keys =
      [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
  };
}
