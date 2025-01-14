{
  config,
  lib,
  ...
}:

let
  inherit (lib) mapAttrs;
  cfg = config.icedos;
in
{
  home-manager.users = mapAttrs (user: _: {
    home.file.".bashrc".text = ""; # Avoid file not found errors
  }) cfg.system.users;

  security.sudo.extraConfig = "Defaults pwfeedback"; # Show asterisks when typing sudo password
}
