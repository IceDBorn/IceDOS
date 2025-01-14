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
    ;

  cfg = config.icedos;

  package = (
    pkgs.librewolf.override {
      nativeMessagingHosts = [ inputs.pipewire-screenaudio.packages.${pkgs.system}.default ];
    }
  );

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
      cfg.applications.librewolf.enable && cfg.applications.defaultBrowser == "librewolf"
    ) "${package}/bin/librewolf";

    systemPackages = if (cfg.applications.librewolf.enable) then [ package ] else [ ];
  };

  home-manager.users = mapAttrs (user: _: {
    home.file = mkIf (cfg.applications.librewolf.enable) {
      ".librewolf/profiles.ini" = {
        source = ./profiles.ini;
        force = true;
      };
    };

    xdg.desktopEntries.librewolf-pwas =
      mkIf (cfg.applications.librewolf.enable && cfg.applications.librewolf.pwas.enable)
        {
          exec = "librewolf-pwas";
          icon = "librewolf";
          name = "Librewolf PWAs";
          terminal = false;
          type = "Application";
        };
  }) cfg.system.users;
}
