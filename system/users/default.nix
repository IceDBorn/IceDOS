{ config, lib, ... }: {
  imports = [ ./main.nix ./work.nix ];

  nix.settings.trusted-users = [ "root" ]
    ++ lib.optional config.system.user.main.enable
    config.system.user.main.username
    ++ lib.optional config.system.user.work.enable
    config.system.user.work.username;
}
