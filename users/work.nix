{ config, pkgs, ... }:

{
    users.users.work = {
        createHome = true;
        home = "/home/work";
        useDefaultShell = true;
        # Default password used for first login, change later with passwd
        password = "1";
        isNormalUser = true;
        description = "Work";
        extraGroups = [ "networkmanager" "wheel" ];
    };
}