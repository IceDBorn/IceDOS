{
  config,
  lib,
  pkgs,
}:

let
  inherit (lib) attrNames filter strings;
  cfg = config.icedos.system;

  gens = builtins.toString (cfg.generations.garbageCollect.generations);
  days = builtins.toString (cfg.generations.garbageCollect.days);
in
pkgs.writeShellScriptBin "nix-gc" ''
  # Retain sudo
  trap "exit" INT TERM; trap "kill 0" EXIT; sudo -v || exit $?; sleep 1; while true; do sleep 60; sudo -nv; done 2>/dev/null &

  # Garbage collect user profiles
  ${
    let
      users = filter (user: cfg.users.${user}.enable == true) (attrNames cfg.users);
    in
    strings.concatMapStrings (
      user:
      let
        username = cfg.users.${user}.username;
      in
      ''
        sudo -H -u "${username}" env Gens="''${1:-${gens}}" Days="''${2:-${days}}" bash -c 'trim-generations "$Gens" "$Days" "user"'
        sudo -H -u "${username}" env Gens="''${1:-${gens}}" Days="''${2:-${days}}" bash -c 'trim-generations "$Gens" "$Days" "home-manager"'
      ''
    ) users
  }

  # Garbage collect system profiles
  sudo trim-generations "''${1:-${gens}}" "''${2:-${days}}" system

  # Garbage collect the nix store
  nix-store --gc
''
