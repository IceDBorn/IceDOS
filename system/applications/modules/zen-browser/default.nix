{
  pkgs,
  lib,
  config,
  inputs,
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

  package = (inputs.zen-browser.packages."${pkgs.system}".default);

  zen-pwas = import ./pwas-wrapper.nix { inherit config pkgs; };
  mapAttrsAndKeys = callback: list: (foldl' (acc: value: acc // (callback value)) { } list);
in
{
  imports = [ ./user.js.nix ];

  # Set as default browser for electron apps
  environment = {
    sessionVariables.DEFAULT_BROWSER = mkIf (
      cfg.applications.zen-browser.enable && cfg.applications.zen-browser.default
    ) "${package}/bin/zen";
    systemPackages = [
      package
    ] ++ optional (cfg.applications.zen-browser.pwas.enable) zen-pwas;
  };

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
        ${username} = mkIf (cfg.applications.zen-browser.enable) {
          home.file = {
            # Set profiles
            ".zen/profiles.ini" = {
              source = ./profiles.ini;
              force = true;
            };
          };

          xdg.desktopEntries.zen-pwas = mkIf (cfg.applications.zen-browser.pwas.enable) {
            exec = "zen-pwas";
            icon = "zen";
            name = "Zen PWAs";
            terminal = false;
            type = "Application";
          };
        };
      }
    ) users;
}
