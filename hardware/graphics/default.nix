{
  config,
  lib,
  ...
}:

let
  inherit (lib) filterAttrs attrNames;
  cfg = config.icedos;

  getModules =
    path:
    map (dir: ./. + ("/modules/" + dir)) (
      attrNames (filterAttrs (n: v: v == "directory") (builtins.readDir path))
    );
in
{
  imports = getModules (./modules);

  hardware.graphics = {
    enable = cfg.hardware.graphics.enable;
    enable32Bit = true;
  };
}
