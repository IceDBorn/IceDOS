{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mapAttrs mapAttrsToList;
in
{
  environment.systemPackages = [
    (pkgs.writeShellScriptBin "list-pkgs" "nix-store --query --requisites /run/current-system | cut -d- -f2- | sort | uniq")
    (pkgs.writeShellScriptBin "repair-store" "nix-store --verify --check-contents --repair")
  ];

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
