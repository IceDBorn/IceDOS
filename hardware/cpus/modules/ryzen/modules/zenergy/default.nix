{
  config,
  lib,
  ...
}:

let
  inherit (lib) mkIf versionAtLeast;
  cfg = config.icedos;
in
mkIf (cfg.hardware.cpus.ryzen.zenergy) {
  boot = {
    kernelModules = [ "zenergy" ];

    extraModulePackages =
      with config.boot.kernelPackages;
      if (versionAtLeast kernel.version "6.16") then
        [
          (zenergy.overrideAttrs (super: {
            patches = (super.patches or [ ]) ++ [ ./patch.diff ];
          }))
        ]
      else
        [ zenergy ];
  };
}
