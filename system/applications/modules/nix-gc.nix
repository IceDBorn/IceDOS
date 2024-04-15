{ config, pkgs }:

let
  cfg = config.icedos.system;
in
pkgs.writeShellScriptBin "nix-gc" ''
  gens=${cfg.generations.garbageCollect.generations}
  days=${cfg.generations.garbageCollect.days}
  trim-generations ''${1:-$gens} ''${2:-$days} user
  trim-generations ''${1:-$gens} ''${2:-$days} home-manager
  sudo -H -u ${cfg.user.work.username} env Gens="''${1:-$gens}" Days="''${2:-$days}" bash -c 'trim-generations $Gens $Days user'
  sudo -H -u ${cfg.user.work.username} env Gens="''${1:-$gens}" Days="''${2:-$days}" bash -c 'trim-generations $Gens $Days home-manager'
  sudo trim-generations ''${1:-$gens} ''${2:-$days} system
  nix-store --gc
''
