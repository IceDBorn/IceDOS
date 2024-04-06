{ config, inputs, ... }:

let
  cfg = config.icedos.system.config;
in
{
  imports = [
    ./configs/codium.nix
    ./configs/firefox/user.js.nix
    ./configs/nvchad/init.nix
    ./global.nix
    ./home.nix
    ./main.nix
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

    # Add extra channels (Ex. pkgs.master.firefox)
    packageOverrides = pkgs: {
      master = import inputs.master { config = config.nixpkgs.config; };
      small = import inputs.small { config = config.nixpkgs.config; };
      stable = import inputs.stable { config = config.nixpkgs.config; };
    };
  };

  # Versioning system
  environment.etc."icedos-version".text = cfg.version;
}
