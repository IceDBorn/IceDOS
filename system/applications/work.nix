# PACKAGES INSTALLED ON WORK USER
{ config, pkgs, lib, inputs, ... }:

let
  stashLock = if (config.system.update.stash-flake-lock) then "1" else "0";

  # Rebuild the system configuration
  update = pkgs.writeShellScriptBin "update" "rebuild 1 ${stashLock} 0";
  shellScripts = [ update ];

  gitLocation = "/home/${config.system.user.work.username}/git/";
  projectName = "smart-trade";
in lib.mkIf config.system.user.work.enable {
  users.users.${config.system.user.work.username}.packages = with pkgs;
    [
      apacheHttpd # HTTP Server
      beekeeper-studio # Database manager
      google-chrome-dev # Dev browser
      php # Programming language for websites
      phpPackages.composer # Package manager for PHP
    ] ++ shellScripts;

  services = {
    httpd = {
      enable = true;
      user = config.system.user.work.username;
      phpPackage = inputs.phps.packages.x86_64-linux.php74;
      enablePHP = true;
      extraConfig = ''
        <VirtualHost *:80>
          ServerName ${config.system.user.work.username}.localhost
          ServerAdmin ${config.system.user.work.username}@localhost
          DocumentRoot ${gitLocation}
          Alias /burkani ${gitLocation}${projectName}
          <Directory ${gitLocation}>
            AllowOverride all
            Options Indexes FollowSymLinks MultiViews
            Order Deny,Allow
            Allow from all
            Require all granted
          </Directory>
        </VirtualHost>
      '';
    };

    mysql = {
      enable = true;
      package = pkgs.mysql;
    };
  };

}
