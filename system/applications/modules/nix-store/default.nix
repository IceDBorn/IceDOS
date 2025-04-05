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
  icedos.internals.toolset.commands = [
    (
      let
        command = "pkgs";
      in
      {
        bin = "${pkgs.writeShellScript command "nix-store --query --requisites /run/current-system | cut -d- -f2- | sort | uniq"}";
        command = command;
        help = "list all installed packages";
      }
    )

    (
      let
        command = "repair";
      in
      {
        bin = "${pkgs.writeShellScript command "nix-store --verify --check-contents --repair"}";
        command = command;
        help = "repair nix store";
      }
    )
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
