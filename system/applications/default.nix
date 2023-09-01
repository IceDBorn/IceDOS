{ config, ... }:

{
  imports = [
    ./global.nix # Packages installed globally
    ./main.nix # Packages installed for main user
    ./work.nix # Packages installed for work user
    # Home manager specific stuff
    ./home/main.nix
    ./home/work.nix
  ];

  nix = {
    settings = {
      # Use hard links to save space (slows down package manager)
      auto-optimise-store = true;
      experimental-features = [ "nix-command" "flakes" ]; # Enable flakes
      substituters = if (config.local.cache.enable) then [
        "https://hyprland.cachix.org"
        "http://192.168.1.2:8080"
      ] else
        [ "https://hyprland.cachix.org" ];
      trusted-public-keys = [
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      ];
    };

    # Automatic garbage collection
    gc = {
      automatic = true;
      dates = "weekly";
    };
  };

  nixpkgs.config = {
    allowUnfree = true; # Allow proprietary packages
    permittedInsecurePackages = [ "openssl-1.1.1v" ];
  };
}
