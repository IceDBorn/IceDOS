{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) attrNames filter foldl';
  cfg = config.icedos;
  mapAttrsAndKeys = callback: list: (foldl' (acc: value: acc // (callback value)) { } list);
in
{
  environment.systemPackages = [
    (pkgs.btop.override {
      cudaSupport = cfg.hardware.gpus.nvidia.enable;
      rocmSupport = cfg.hardware.gpus.amd;
    })
  ];

  home-manager.users =
    let
      users = filter (user: cfg.system.users.${user}.enable == true) (attrNames cfg.system.users);
    in
    mapAttrsAndKeys (
      user:
      let
        username = cfg.system.users.${user}.username;
      in
      {
        ${username} = {
          home.file.".config/btop/btop.conf".source = ./btop.conf;
        };
      }
    ) users;
}
