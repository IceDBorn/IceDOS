# PACKAGES INSTALLED ON WORK USER
{ config, pkgs, lib, inputs, ... }:

let
  stashLock = if (config.system.update.stash-flake-lock) then "1" else "0";

  # Rebuild the system configuration
  update = pkgs.writeShellScriptBin "update" "rebuild 1 ${stashLock} 0";
  shellScripts = [ update ];

  gitLocation = "/home/${config.system.user.work.username}/git";
  projectName = "fromcreta";
in lib.mkIf config.system.user.work.enable {
  users.users.${config.system.user.work.username}.packages = with pkgs;
    [
      apacheHttpd
      phpPackages.composer
      jetbrains.datagrip
      php
      phpPackages.composer
      google-chrome-dev
    ] ++ shellScripts;

  services = {
    httpd = {
      enable = true;
      user = config.system.user.work.username;
      phpPackage = inputs.phps.packages.x86_64-linux.php73;
      enablePHP = true;
      virtualHosts = {
        localhost = {
          documentRoot = "${gitLocation}/${projectName}";
          locations."/".index = "index.php";
        };
      };
    };

    mysql = {
      enable = true;
      package = pkgs.mysql;
    };
  };

}
