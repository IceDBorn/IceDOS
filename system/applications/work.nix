# PACKAGES INSTALLED ON WORK USER
{ config, pkgs, lib, ... }:

let
  # Rebuild the system configuration
  update = pkgs.writeShellScriptBin "update" "rebuild 1 0";
  shellScripts = [ update ];
in lib.mkIf config.system.user.work.enable {
  users.users.${config.system.user.work.username}.packages = with pkgs;
    [ ] ++ shellScripts;
}
