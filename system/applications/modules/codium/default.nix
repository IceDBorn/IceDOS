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
    ;

  cfg = config.icedos;

  update-codium-extensions = import ./codium-extension-updater.nix { inherit config pkgs; };

  mapAttrsAndKeys = callback: list: (foldl' (acc: value: acc // (callback value)) { } list);
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
    cfg.applications.codium.enable && !cfg.applications.nvchad
  ) "codium";

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
        ${username} = mkIf (cfg.applications.codium.enable) {
          # Enable wayland support for codium
          xdg.desktopEntries.codium = {
            exec = "codium --enable-features=UseOzonePlatform --ozone-platform=wayland";
            icon = "codium";
            name = "VSCodium";
            terminal = false;
            type = "Application";
          };

          # Codium profile used a an IDE
          xdg.desktopEntries.codiumIDE = {
            exec = "codium --user-data-dir ${cfg.system.home}/${username}/.config/VSCodiumIDE --enable-features=UseOzonePlatform --ozone-platform=wayland";
            icon = "codium";
            name = "VSCodium IDE";
            terminal = false;
            type = "Application";
          };
        };
      }
    ) users;
}
