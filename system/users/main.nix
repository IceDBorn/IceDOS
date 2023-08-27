{ config, lib, ... }:

lib.mkIf config.main.user.enable {
  users.users.${config.main.user.username} = {
    createHome = true;
    home = "/home/${config.main.user.username}";
    useDefaultShell = true;
    # Default password used for first login, change later using passwd
    password = "1";
    isNormalUser = true;
    description = "${config.main.user.description}";
    extraGroups = [ "networkmanager" "wheel" "kvm" "docker" "input" ];
  };

  home-manager.users.${config.main.user.username}.home = {
    stateVersion = config.state-version;
    file.".nix-successful-build" = {
      text = "true";
      recursive = true;
    };
  };
}
