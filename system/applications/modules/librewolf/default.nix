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

  package = (
    pkgs.librewolf.override {
      nativeMessagingHosts = [ inputs.pipewire-screenaudio.packages.${pkgs.system}.default ];
    }
  );

  librewolf-pwas = import ./pwas-wrapper.nix { inherit config pkgs; };
in
{
  imports = [ ./user.js.nix ];

  # Set as default browser for electron apps
  environment = {
    sessionVariables.DEFAULT_BROWSER = mkIf (
      cfg.applications.librewolf.enable && cfg.applications.librewolf.default
    ) "${package}/bin/librewolf";

    systemPackages =
      if (cfg.applications.librewolf.enable) then
        [ package ] ++ optional (cfg.applications.librewolf.pwas.enable) librewolf-pwas
      else
        [ ];
  };

  home-manager.users = mapAttrs (user: _: {
    home.file = mkIf (cfg.applications.librewolf.enable) {
      # Set profiles
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
