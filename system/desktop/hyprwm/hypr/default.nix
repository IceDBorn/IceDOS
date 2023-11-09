{ pkgs, lib, config, ... }:

{
  imports = [ ./home/main.nix ./home/work.nix ]; # Setup home manager for hypr

  services.xserver.displayManager.session =
    lib.mkIf config.desktop.hypr [{
      manage = "desktop";
      name = "Hypr";
      start = "Hypr";
    }];

  environment.systemPackages =
    lib.mkIf config.desktop.hypr [ pkgs.hypr ];
}
