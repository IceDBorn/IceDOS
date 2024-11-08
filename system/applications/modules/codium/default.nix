{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mapAttrs mkIf;
  cfg = config.icedos;
  update-codium-extensions = import ./codium-extension-updater.nix { inherit config pkgs; };
in
{
  imports = [ ./options.nix ];

  environment.systemPackages =
    with pkgs;
    mkIf (cfg.applications.codium.enable) [
      vscodium
      update-codium-extensions
    ];

  environment.variables.EDITOR = mkIf (
    cfg.applications.codium.enable && cfg.applications.codium.defaultEditor
  ) "codium -n -w";

  home-manager.users = mapAttrs (user: _: {
    # Codium profile used as an IDE
    xdg.desktopEntries.codiumIDE = mkIf (cfg.applications.codium.enable) {
      exec = "codium --user-data-dir ${cfg.system.home}/${user}/.config/VSCodiumIDE";
      icon = "codium";
      name = "VSCodium IDE";
      terminal = false;
      type = "Application";
    };
  }) cfg.system.users;
}
