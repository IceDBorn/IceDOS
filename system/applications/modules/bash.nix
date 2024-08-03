{ config, lib, ... }:

let
  inherit (lib) attrNames filter foldl';
  cfg = config.icedos;
  mapAttrsAndKeys = callback: list: (foldl' (acc: value: acc // (callback value)) { } list);
in
{
  home-manager.users =
    let
      users = filter (user: cfg.system.users.${user}.enable == true) (attrNames cfg.system.users);
    in
    mapAttrsAndKeys (
      user:
      let
        username = cfg.system.users.${user}.username;
      in
      {
        ${username} = {
          # Avoid file not found errors
          home.file.".bashrc".text = "";
        };
      }
    ) users;

  security.sudo.extraConfig = "Defaults pwfeedback"; # Show asterisks when typing sudo password
}
