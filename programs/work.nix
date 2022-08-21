### PACKAGES INSTALLED ON WORK USER ###
{ config, pkgs, ... }:

{
    users.users.work.packages = with pkgs; [];
}