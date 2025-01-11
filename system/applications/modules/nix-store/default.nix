{
  config,
  inputs,
  lib,
  ...
}:

let
  inherit (lib) mapAttrs mapAttrsToList;
in
{
  nix = {
    # Use flake's nixpkgs input for nix-shell
    nixPath = mapAttrsToList (key: _: "${key}=flake:${key}") config.nix.registry;
    registry = mapAttrs (_: v: { flake = v; }) inputs;

    settings = {
      auto-optimise-store = true;

      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
  };

  nixpkgs.config.allowUnfree = true;
}
