{
  config,
  lib,
  ...
}:

let
  inherit (lib) mapAttrs mkIf;
  cfg = config.icedos;
in

mkIf (cfg.applications.input-remapper) {
  services.input-remapper.enable = true;
  users.users = mapAttrs (user: _: { extraGroups = [ "input" ]; }) cfg.system.users;
}
