{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) concatLines;
  cfg = config.icedos;
  username = "dtek";
  gitLocation = "${cfg.system.home}/${username}/.code/";
  phps = inputs.phps.packages.x86_64-linux;

  stores = [
    {
      alias = "beo";
      folder = "vaza";
    }
    {
      alias = "bktuning";
      folder = "autobase";
    }
    {
      alias = "book";
      folder = "papiros";
    }
    {
      alias = "burkani";
      folder = "vaza";
    }
    {
      alias = "tsm";
      folder = "tosupermou";
    }
  ];

  phpVersion = "php${
    builtins.substring 0 2 (lib.replaceStrings [ "." ] [ "" ] cfg.applications.httpd.php.version)
  }";

  opencartPhpVersions = with phps; [
    php73
    php74
  ];
in
{
  users.users.${username}.packages =
    with pkgs;
    [
      beekeeper-studio
      epiphany
    ]
    ++ opencartPhpVersions;

  services = {
    httpd = {
      phpPackage = phps.${phpVersion};
      extraConfig = ''
        <VirtualHost *:80>
          ServerName ${username}.localhost
          ServerAdmin ${username}@localhost
          DocumentRoot ${gitLocation}
          ${concatLines (map (store: "Alias /${store.alias} ${gitLocation}${store.folder}") stores)}
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
  };
}
