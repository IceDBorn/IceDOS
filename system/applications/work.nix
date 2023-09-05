# PACKAGES INSTALLED ON WORK USER
{ config, pkgs, lib, ... }:

lib.mkIf config.system.user.work.enable {
  users.users.${config.system.user.work.username}.packages = with pkgs; [ ];
}
