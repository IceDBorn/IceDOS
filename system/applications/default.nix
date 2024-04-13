{ config, ... }:

let
  cfg = config.icedos.system.config;
in
{
  imports = [
    ./configs/codium.nix
    ./configs/nvchad/init.nix
    ./global.nix
    ./home.nix
    ./main.nix
    ./modules/firefox
    ./work.nix
  ];

  nix = {
    settings = {
      # Use hard links to save space (slows down package manager)
      auto-optimise-store = true;
      experimental-features = [
        "nix-command"
        "flakes"
      ]; # Enable flakes
    };

    # Automatic garbage collection
    gc = {
      automatic = true;
      dates = "weekly";
    };
  };

  nixpkgs.config = {
    # Allow proprietary packages
    allowUnfree = true;
  };

  # Versioning system
  environment.etc."icedos-version".text = cfg.version;
}
