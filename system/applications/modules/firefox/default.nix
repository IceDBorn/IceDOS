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
    pkgs.firefox.override {
      nativeMessagingHosts = [ inputs.pipewire-screenaudio.packages.${pkgs.system}.default ];
    }
  );

  mapAttrsAndKeys = callback: list: (foldl' (acc: value: acc // (callback value)) { } list);
in
{
  imports = [ ./user.js.nix ];

  programs = mkIf (cfg.applications.firefox.enable) {
    firefox = {
      enable = true;

      # Enable pipewire screenaudio
      package = package;
    };
  };

  # Set as default browser for electron apps
  environment.sessionVariables.DEFAULT_BROWSER = mkIf (cfg.applications.firefox.enable) "${package}/bin/firefox";

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
        ${username} = mkIf (cfg.applications.firefox.enable) {
          home.file = {
            # Set profiles
            ".mozilla/firefox/profiles.ini" = {
              source = ./profiles.ini;
              force = true;
            };
          };

          # Firefox PWA
          xdg.desktopEntries.pwas = {
            exec = "firefox --no-remote -P PWAs --name pwas ${config.icedos.applications.firefox.pwas}";
            icon = "firefox-nightly";
            name = "Firefox PWAs";
            terminal = false;
            type = "Application";
          };
        };
      }
    ) users;
}
