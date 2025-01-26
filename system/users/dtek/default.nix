{
  config,
  pkgs,
  inputs,
  ...
}:

let
  cfg = config.icedos.system;
  username = "dtek";
  gitLocation = "${cfg.home}/${username}/.code/";

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
{
  users.users.${username}.packages = [ pkgs.beekeeper-studio ];

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
      package = pkgs.mariadb;
    };
  };
}
