{ pkgs, lib, config, ... }:

{
  # Setup home manager for hypr
  imports = [ ./home.nix ];

  services.xserver.displayManager.session = lib.mkIf config.desktop.hypr [{
    manage = "desktop";
    name = "Hypr";
    start = "Hypr";
  }];

  environment.systemPackages = lib.mkIf config.desktop.hypr [ pkgs.hypr ];
}
