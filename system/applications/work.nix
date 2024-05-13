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
  };

  # Packages to add for a fork of the config
  myPackages = with pkgs; [ ];

  shellScripts = [
    sail
    update
  ];

  gitLocation = "${cfg.home}/${username}/git/";

  storeAliases = {
    burkani = {
      folder = "vaza";
      alias = "burkani";
    };

    beo = {
      folder = "vaza";
      alias = "beo";
    };

    tosupermoureal = {
      folder = "tosupermou";
      alias = "tsm";
    };

    bookmarkt = {
      folder = "papiros";
      alias = "book";
    };
  };

  httpdAliases = ''
    Alias /${storeAliases.burkani.alias} ${gitLocation}${storeAliases.burkani.folder}
    Alias /${storeAliases.beo.alias} ${gitLocation}${storeAliases.beo.folder}
    Alias /${storeAliases.tosupermoureal.alias} ${gitLocation}${storeAliases.tosupermoureal.folder}
    Alias /${storeAliases.bookmarkt.alias} ${gitLocation}${storeAliases.bookmarkt.folder}
  '';
in
mkIf (cfg.user.work.enable) {
  users.users.${username}.packages =
    with pkgs;
    [
      beekeeper-studio # Database manager
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
      phpPackage = inputs.phps.packages.x86_64-linux.php74;
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
