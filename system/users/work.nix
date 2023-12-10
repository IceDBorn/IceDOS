{ config, lib, ... }:

lib.mkIf config.system.user.work.enable {
  users.users.${config.system.user.work.username} = {
    createHome = true;
    home = "${config.system.home}/${config.system.user.work.username}";
    useDefaultShell = true;
    # Default password used for first login, change later using passwd
    password = "1";
    isNormalUser = true;
    description = "${config.system.user.work.description}";
    extraGroups = [ "networkmanager" "wheel" "kvm" "docker" "input" ];
  };

  home-manager.users.${config.system.user.work.username}.home = {
    stateVersion = config.system.version;
    file.".nix-successful-build" = {
      text = "true";
      recursive = true;
    };
  };
}
