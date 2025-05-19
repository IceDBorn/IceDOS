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
    filterAttrs
    mapAttrs
    mkIf
    ;

  cfg = config.icedos;

  package = (
    pkgs.librewolf.override {
      nativeMessagingHosts = [ inputs.pipewire-screenaudio.packages.${pkgs.system}.default ];
    }
  );

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
      cfg.applications.librewolf && cfg.applications.defaultBrowser == "librewolf"
    ) "${package}/bin/librewolf";

    systemPackages = if (cfg.applications.librewolf) then [ package ] else [ ];
  };

  home-manager.users = mapAttrs (user: _: {
    home.file = mkIf (cfg.applications.librewolf) {
      ".librewolf/profiles.ini" = {
        source = ./profiles.ini;
        force = true;
      };
    };
  }) cfg.system.users;
}
