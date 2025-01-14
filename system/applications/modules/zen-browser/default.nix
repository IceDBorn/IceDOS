{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:

let
  inherit (lib)
    filterAttrs
    mapAttrs
    mkIf
    optional
    ;

  cfg = config.icedos;
  package = (inputs.zen-browser.packages."${pkgs.system}".default);

  getModules =
    path:
    builtins.map (dir: ./. + ("/modules/" + dir)) (
      builtins.attrNames (
        filterAttrs (n: v: v == "directory" && !(n == "zen-browser")) (builtins.readDir path)
      )
    );
in
{
  imports = getModules (./modules);

  # Set as default browser for electron apps
  environment = {
    sessionVariables.DEFAULT_BROWSER = mkIf (
      cfg.applications.zen-browser.enable && cfg.applications.defaultBrowser == "zen"
    ) "${package}/bin/zen";

    systemPackages = [ package ];
  };

  home-manager.users = mapAttrs (user: _: {
    home.file = mkIf (cfg.applications.zen-browser.enable) {
      ".zen/profiles.ini" = {
        source = ./profiles.ini;
        force = true;
      };
    };

    xdg.desktopEntries.zen-pwas =
      mkIf (cfg.applications.zen-browser.enable && cfg.applications.zen-browser.pwas.enable)
        {
          exec = "zen-pwas";
          icon = "zen";
          name = "Zen PWAs";
          terminal = false;
          type = "Application";
        };
  }) cfg.system.users;
}
