{
  config,
  lib,
  ...
}:

let
  inherit (lib) listToAttrs;
  cfg = config.icedos.hardware;
in
{
  fileSystems = listToAttrs (
    map (mount: {
      name = mount.path;

      value = {
        device = mount.device;
        fsType = mount.fsType;
        options = mount.flags;
      };
    }) cfg.mounts
  );
}
