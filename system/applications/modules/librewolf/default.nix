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
    ;

  cfg = config.icedos;

  package = (
    pkgs.librewolf.override {
      nativeMessagingHosts = [ inputs.pipewire-screenaudio.packages.${pkgs.system}.default ];
    }
  );

  librewolf-pwas = import ./pwas-wrapper.nix { inherit config pkgs; };
  mapAttrsAndKeys = callback: list: (foldl' (acc: value: acc // (callback value)) { } list);
in
{
  imports = [ ./user.js.nix ];

  # Set as default browser for electron apps
  environment = {
    sessionVariables.DEFAULT_BROWSER = mkIf (cfg.applications.librewolf.enable) "${package}/bin/librewolf";
    systemPackages = [
      librewolf-pwas
      package
    ];
  };

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
        ${username} = mkIf (cfg.applications.librewolf.enable) {
          home.file = {
            # Set profiles
            ".librewolf/profiles.ini" = {
              source = ./profiles.ini;
              force = true;
            };
          };

          xdg.desktopEntries.pwas = {
            exec = "librewolf-pwas";
            icon = "librewolf";
            name = "Librewolf PWAs";
            terminal = false;
            type = "Application";
          };
        };
      }
    ) users;
}
