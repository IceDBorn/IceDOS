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
  imports = getModules (./modules);

  boot = {
    kernelParams = [
      "amd-pstate=active"
      "amd_pstate.shared_mem=1"
    ];

    kernelModules = [
      "amd-pstate"
      "msr"
    ];
  };

  hardware.cpu.amd.updateMicrocode = true;
}
