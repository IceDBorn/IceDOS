{ config, pkgs, ... }:

{
    users.users.icedborn = {
        createHome = true;
        home = "/home/icedborn";
        useDefaultShell = true;
        # Default password used for first login, change later with passwd
        password = "1";
        isNormalUser = true;
        description = "IceDBorn";
        extraGroups = [ "networkmanager" "wheel" ];
    };
}