{ config, lib, ... }:

let
  mapAttrsAndKeys = callback: list:
    (lib.foldl' (acc: value: acc // (callback value)) { } list);
  users = lib.filter (user: config.system.user.${user}.enable == true)
    (lib.attrNames config.system.user);
in {
  nix.settings.trusted-users = [ "root" ]
    ++ (lib.foldl' (acc: user: acc ++ [ config.system.user.${user}.username ])
      [ ] users);

  users.users = mapAttrsAndKeys (user:
    let
      username = config.system.user.${user}.username;
      description = config.system.user.${user}.description;
    in {
      ${username} = {
        createHome = true;
        home = "${config.system.home}/${username}";
        useDefaultShell = true;
        # Default password used for first login, change later using passwd
        password = "1";
        isNormalUser = true;
        description = "${description}";
        extraGroups = [ "networkmanager" "wheel" "kvm" "docker" "input" ];
      };
    }) users;

  home-manager.users = mapAttrsAndKeys (user:
    let username = config.system.user.${user}.username;
    in { ${username}.home.stateVersion = config.system.version; }) users;
}
