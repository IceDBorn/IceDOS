{ config, lib, ... }:

let
  inherit (lib) attrNames filter foldl';

  cfg = config.icedos.system;

  mapAttrsAndKeys = callback: list: (foldl' (acc: value: acc // (callback value)) { } list);
  users = filter (user: cfg.users.${user}.enable == true) (attrNames cfg.users);
in
{
  nix.settings.trusted-users = [
    "root"
  ] ++ (foldl' (acc: user: acc ++ [ cfg.users.${user}.username ]) [ ] users);

  users.users = mapAttrsAndKeys (
    user:
    let
      username = cfg.users.${user}.username;
      description = cfg.users.${user}.description;
    in
    {
      ${username} = {
        createHome = true;
        home = "${cfg.home}/${username}";
        useDefaultShell = true;
        # Default password used for first login, change later using passwd
        password = "1";
        isNormalUser = true;
        description = "${description}";
        extraGroups = [
          "docker"
          "input"
          "kvm"
          "networkmanager"
          "wheel"
        ];
      };
    }
  ) users;

  home-manager.users = mapAttrsAndKeys (
    user:
    let
      username = cfg.users.${user}.username;
    in
    {
      ${username}.home.stateVersion = cfg.version;
    }
  ) users;
}
