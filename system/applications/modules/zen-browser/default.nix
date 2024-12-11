{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:

let
  inherit (lib) mapAttrs mkIf optional;
  cfg = config.icedos;
  package = (inputs.zen-browser.packages."${pkgs.system}".default);
  zen-pwas = import ./pwas-wrapper.nix { inherit config pkgs; };
in
{
  imports = [ ./user.js.nix ];

  # Set as default browser for electron apps
  environment = {
    sessionVariables.DEFAULT_BROWSER = mkIf (
      cfg.applications.zen-browser.enable && cfg.applications.defaultBrowser == "zen"
    ) "${package}/bin/zen";
    systemPackages = [
      package
    ] ++ optional (cfg.applications.zen-browser.pwas.enable) zen-pwas;
  };

  home-manager.users = mapAttrs (user: _: {
    home.file = mkIf (cfg.applications.zen-browser.enable) {
      # Set profiles
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
