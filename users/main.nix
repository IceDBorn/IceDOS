{ config, pkgs, ... }:

{
    users.users.${config.main.user.username} = {
        createHome = true;
        home = "/home/${config.main.user.username}";
        useDefaultShell = true;
        # Default password used for first login, change later with passwd
        password = "1";
        isNormalUser = true;
        description = "${config.main.user.description}";
        extraGroups = [ "networkmanager" "wheel" "kvm" ];
    };
}
