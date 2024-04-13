{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib)
    attrNames
    filter
    foldl'
    mkIf
    optional
    ;

  cfg = config.icedos;

  update-codium-extensions = import ./codium-extension-updater.nix { inherit pkgs; };

  mapAttrsAndKeys = callback: list: (foldl' (acc: value: acc // (callback value)) { } list);
in
{
  imports = [ ./options.nix ];

  environment.systemPackages =
    with pkgs;
    mkIf (cfg.applications.codium) [
      vscodium
      update-codium-extensions
    ];

  home-manager.users =
    let
      users = filter (user: cfg.system.user.${user}.enable == true) (attrNames cfg.system.user);
    in
    mapAttrsAndKeys (
      user:
      let
        username = cfg.system.user.${user}.username;
      in
      {
        # Codium profile used a an IDE
        ${username}.xdg.desktopEntries.codiumIDE = mkIf (cfg.applications.firefox.enable) {
          exec = "codium --user-data-dir ${cfg.system.home}/${username}/.config/VSCodiumIDE";
          icon = "codium";
          name = "Codium IDE";
          terminal = false;
          type = "Application";
        };
      }
    ) users;
}
