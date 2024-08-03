{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib)
    attrNames
    filter
    foldl'
    mkIf
    ;

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
          home.file = {
            # Add btop config
            ".config/btop/btop.conf".source = configs/btop.conf;

            # Add tmux
            ".config/tmux/tmux.conf".source = configs/tmux.conf;

            ".config/tmux/tpm" = {
              source = pkgs.tpm;
              recursive = true;
            };

            # Avoid file not found errors for bash
            ".bashrc".text = "";
          };
        };
      }
    ) users;
}
