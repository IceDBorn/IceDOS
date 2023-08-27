{ pkgs, ... }:

{
  imports = [ ./home-main.nix ./home-work.nix ]; # Setup home manager for hypr

  services.xserver.displayManager.session = [{
    manage = "desktop";
    name = "Hypr";
    start = "Hypr";
  }];

  environment.systemPackages = with pkgs; [ hypr ];
}
