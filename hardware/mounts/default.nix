{
  config,
  lib,
  ...
}:

let
  inherit (lib) mkIf;
  cfg = config.icedos.hardware;
in
{
  fileSystems = builtins.listToAttrs (
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
