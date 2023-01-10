### PACKAGES INSTALLED ON WORK USER ###
{ config, pkgs, lib, ... }:

{
	users.users.${config.work.user.username}.packages = with pkgs; lib.mkIf config.work.user.enable [];
}
