{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:

let
  inherit (lib) filterAttrs mkIf;

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
}
