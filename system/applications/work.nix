# PACKAGES INSTALLED ON WORK USER
{ config, pkgs, lib, ... }:

let
  stashLock = if (config.system.update.stash-flake-lock) then "1" else "0";

  # Rebuild the system configuration
  update = pkgs.writeShellScriptBin "update" "rebuild 1 ${stashLock} 0";
  shellScripts = [ update ];
in lib.mkIf config.system.user.work.enable {
  users.users.${config.system.user.work.username}.packages = with pkgs;
    [ ] ++ shellScripts;
}
