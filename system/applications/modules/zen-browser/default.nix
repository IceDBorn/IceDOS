{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:

let
  inherit (lib) attrNames filterAttrs mkIf;

  cfg = config.icedos;
  package = (inputs.zen-browser.packages."${pkgs.system}".default);

  getModules =
    path:
    map (dir: ./. + ("/modules/" + dir)) (
      attrNames (filterAttrs (n: v: v == "directory") (builtins.readDir path))
    );
in
{
  imports = getModules (./modules);

  # Set as default browser for electron apps
  environment = {
    sessionVariables.DEFAULT_BROWSER = mkIf (
      cfg.applications.zen-browser.enable && cfg.applications.defaultBrowser == "zen"
    ) "${package}/bin/zen-beta";

    systemPackages = [ package ];
  };
}
