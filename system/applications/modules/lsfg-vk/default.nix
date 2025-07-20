{
  config,
  lib,
  ...
}:

let
  inherit (lib) mapAttrs mkIf;
  cfg = config.icedos;
  lsfg-vk = cfg.applications.lsfg-vk;
in
mkIf (lsfg-vk.enable) {
  services.lsfg-vk.enable = true;

  home-manager.users = mapAttrs (user: _: {
    home.file.".config/lsfg-vk/conf.toml" = {
      force = true;

      text = ''
        version = 1
        [global]
        dll = "${lsfg-vk.dllPath}"

        [[game]]
        exe = "lsfg-vk-default"
        multiplier = 2
        performance_mode = true

        [[game]]
        exe = "lsfg-vk-hdr"
        hdr_mode = true
        multiplier = 2
        performance_mode = true
      '';
    };
  }) cfg.system.users;
}
