{
  lib,
  ...
}:

let
  inherit (lib) attrNames filterAttrs;

  getModules =
    path:
    map (dir: ./. + ("/modules/" + dir)) (
      attrNames (filterAttrs (n: v: v == "directory") (builtins.readDir path))
    );
in
{
  imports = getModules ./modules;
}
