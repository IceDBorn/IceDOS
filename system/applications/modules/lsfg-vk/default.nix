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
  services.lsfg-vk.enable = true;

  environment.variables = {
    LSFG_DLL_PATH = lsfg-vk.dllPath;
    LSFG_PERF_MODE = 1;
  };
}
