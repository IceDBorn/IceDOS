{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) mapAttrs;
  cfg = config.icedos;
in
{
  environment.systemPackages = [ pkgs.tmux ];
  home-manager.users = mapAttrs (user: _: {
    home.file = {
      ".config/tmux/tmux.conf".source = ./tmux.conf;

      ".config/tmux/tpm" = {
        source = pkgs.tpm;
        recursive = true;
      };
    };
  }) cfg.system.users;
}
