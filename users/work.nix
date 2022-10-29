{ config, pkgs, ... }:

{
    users.users.${config.work.user.username} = {
        createHome = true;
        home = "/home/${config.work.user.username}";
        useDefaultShell = true;
        # Default password used for first login, change later with passwd
        password = "1";
        isNormalUser = true;
        description = "${config.work.user.description}";
        extraGroups = [ "networkmanager" "wheel" "kvm" ];
    };
}
