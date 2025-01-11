{
  config,
  lib,
  ...
}:

let
  inherit (lib)
    attrNames
    mapAttrs
    foldl'
    optional
    ;

  cfg = config.icedos.system;
in
{
  nix.settings.trusted-users = [
    "root"
  ] ++ (foldl' (acc: user: acc ++ [ user ]) [ ] (attrNames cfg.users));

  users.users = mapAttrs (
    user: _:
    let
      description = cfg.users.${user}.description;
    in
    {
      createHome = true;
      home = "${cfg.home}/${user}";
      useDefaultShell = true;
      # Default password used for first login, change later using passwd
      password = "1";
      isNormalUser = true;
      description = "${description}";
      extraGroups =
        [
          "input"
          "kvm"
          "networkmanager"
          "wheel"
        ]
        ++ optional (
          !cfg.virtualisation.containerManager.usePodman
          && !cfg.virtualisation.containerManager.requireSudoForDocker
        ) "docker";
    }
  ) cfg.users;

  home-manager.users = mapAttrs (user: _: { home.stateVersion = cfg.version; }) cfg.users;
}
