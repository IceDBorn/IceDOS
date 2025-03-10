{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) concatLines;
  cfg = config.icedos.system;
  username = "dtek";
  gitLocation = "${cfg.home}/${username}/.code/";

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
in
{
  users.users.${username}.packages = with pkgs; [
    beekeeper-studio
    epiphany
  ];

  services = {
    httpd = {
      phpPackage = inputs.phps.packages.x86_64-linux.php73;
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
