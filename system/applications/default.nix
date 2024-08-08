{
  config,
  inputs,
  lib,
  ...
}:

let
  inherit (lib) mapAttrs mapAttrsToList;
  cfg = config.icedos.system.config;
in
{
  imports = [ ./global.nix ];

  nix = {
    # Automatic garbage collection
    gc = {
      automatic = true;
      dates = "weekly";
    };

    # Use flake's nixpkgs input for nix-shell
    nixPath = mapAttrsToList (key: _: "${key}=flake:${key}") config.nix.registry;
    registry = mapAttrs (_: v: { flake = v; }) inputs;

    settings = {
      # Use hard links to save space (slows down package manager)
      auto-optimise-store = true;

      # Enable flakes
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
  };

  # Allow proprietary packages
  nixpkgs.config.allowUnfree = true;

  # Versioning system
  environment.etc."icedos-version".text = cfg.version;
}
