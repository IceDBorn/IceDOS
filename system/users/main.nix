{ config, lib, ... }:

lib.mkIf config.system.user.main.enable {
  users.users.${config.system.user.main.username} = {
    createHome = true;
    home = "${config.system.home}/${config.system.user.main.username}";
    useDefaultShell = true;
    # Default password used for first login, change later using passwd
    password = "1";
    isNormalUser = true;
    description = "${config.system.user.main.description}";
    extraGroups = [ "networkmanager" "wheel" "kvm" "docker" "input" ];
  };

  home-manager.users.${config.system.user.main.username}.home = {
    stateVersion = config.system.version;
    file.".nix-successful-build" = {
      text = "true";
      recursive = true;
    };
  };
}
