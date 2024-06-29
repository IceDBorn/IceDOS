{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mkIf;

  cfg = config.icedos.desktop;
in
{
  imports = [ ./home.nix ];

  catppuccin = mkIf (config.icedos.desktop.plasma) {
    enable = true;
    accent = "mauve";
    flavor = "mocha";
  };

  console.catppuccin.enable = false;

  services = mkIf (config.icedos.desktop.plasma) {
    desktopManager.plasma6.enable = true;

    displayManager.sddm = mkIf (!cfg.gdm.enable && cfg.sddm) {
      enable = true;
      enableHidpi = true;

      wayland = {
        enable = true;
        compositor = "kwin";
      };
    };
  };

  environment.systemPackages =
    with pkgs;
    mkIf (config.icedos.desktop.plasma) [
      (catppuccin-kde.override {
        accents = [ "mauve" ];
        flavour = [ "macchiato" ];
        winDecStyles = [ "classic" ];
      }) # KDE Theme

      gparted # QT Disks app
      libsForQt5.krohnkite # Tiling extension
    ];
}
