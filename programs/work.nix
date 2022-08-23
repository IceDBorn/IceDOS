### PACKAGES INSTALLED ON WORK USER ###
{ config, pkgs, ... }:

{
    users.users.${config.work.user.username}.packages = with pkgs; [];
}
