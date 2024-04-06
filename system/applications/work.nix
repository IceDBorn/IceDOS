# PACKAGES INSTALLED ON WORK USER
{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:

let
  inherit (lib) mkIf;

  cfg = config.icedos.system;
  username = cfg.user.work.username;

  sail = import modules/run-command.nix {
    inherit pkgs;
    name = "sail";
    command = "vendor/bin/sail";
  };

  # Update the system configuration
  update = import modules/rebuild.nix {
    inherit pkgs config;
    command = "update";
    update = "true";
    stash = cfg.update.stash;
  };

  # Packages to add for a fork of the config
  myPackages = with pkgs; [ ];

  shellScripts = [
    sail
    update
  ];

  gitLocation = "${cfg.home}/${username}/git/";

  multiStoreProjects = {
    vaza = {
      folder = "vaza";

      aliases = {
        one = "burkani";
        two = "beo";
      };
    };

    tosupermou = {
      folder = "tosupermou";
      alias = "tosupermoureal";
    };

    papiros = {
      folder = "papiros";
      alias = "bookmarkt";
    };
  };

  httpdAliases = ''
    Alias /${multiStoreProjects.vaza.aliases.one} ${gitLocation}${multiStoreProjects.vaza.folder}
    Alias /${multiStoreProjects.vaza.aliases.two} ${gitLocation}${multiStoreProjects.vaza.folder}
    Alias /${multiStoreProjects.tosupermou.alias} ${gitLocation}${multiStoreProjects.tosupermou.folder}
    Alias /${multiStoreProjects.papiros.alias} ${gitLocation}${multiStoreProjects.papiros.folder}
  '';
in
mkIf (cfg.user.work.enable) {
  users.users.${username}.packages =
    with pkgs;
    [
      dbeaver # Database manager
      google-chrome # Dev browser
      php # Programming language for websites
      phpPackages.composer # Package manager for PHP
    ]
    ++ myPackages
    ++ shellScripts;

  services = {
    httpd = {
      enable = true;
      user = username;
      phpPackage = inputs.phps.packages.x86_64-linux.php73;
      enablePHP = true;
      extraConfig = ''
        <VirtualHost *:80>
          ServerName ${username}.localhost
          ServerAdmin ${username}@localhost
          DocumentRoot ${gitLocation}
          ${httpdAliases}
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
