{
  config,
  lib,
  ...
}:

let
  inherit (lib) mkIf;
  cfg = config.icedos;
  lsfg-vk = cfg.applications.lsfg-vk;
in
mkIf (lsfg-vk.enable) {
  services.lsfg-vk = {
    enable = true;
    losslessDLLFile = lsfg-vk.dllPath;
  };

  environment.variables.LSFG_PERF_MODE = 1;
}
