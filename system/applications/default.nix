{ config, ... }:

let
  cfg = config.icedos.system.config;
in
{
  imports = [
    ./global.nix
    ./home.nix
  ];

  nix = {
    settings = {
      # Use hard links to save space (slows down package manager)
      auto-optimise-store = true;

      # Enable flakes
      experimental-features = [
        "nix-command"
        "flakes"
      ];
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
