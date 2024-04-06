{ config, lib, ... }:

let
  inherit (lib) attrNames filter foldl';

  cfg = config.icedos.system;

  mapAttrsAndKeys = callback: list: (foldl' (acc: value: acc // (callback value)) { } list);
  users = filter (user: cfg.user.${user}.enable == true) (attrNames cfg.user);
in
{
  nix.settings.trusted-users = [
    "root"
  ] ++ (foldl' (acc: user: acc ++ [ cfg.user.${user}.username ]) [ ] users);

  users.users = mapAttrsAndKeys (
    user:
    let
      username = cfg.user.${user}.username;
      description = cfg.user.${user}.description;
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
          "networkmanager"
          "wheel"
          "kvm"
          "docker"
          "input"
        ];
      };
    }
  ) users;

  home-manager.users = mapAttrsAndKeys (
    user:
    let
      username = cfg.user.${user}.username;
    in
    {
      ${username}.home.stateVersion = cfg.version;
    }
  ) users;
}
