{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) filter mapAttrs;
  cfg = config.icedos;
  profiles = filter (profile: profile.pwa) cfg.applications.zen-browser.profiles;
in
{
  environment.systemPackages = map (
    profile:
    pkgs.writeShellScriptBin profile.exec ''
      zen --no-remote -P ${profile.exec} --name "${profile.exec}" ${builtins.toString profile.sites}
    ''
  ) profiles;

  home-manager.users = mapAttrs (user: _: {
    xdg.desktopEntries = builtins.listToAttrs (
      map (profile: {
        name = profile.exec;

        value = {
          exec = profile.exec;
          icon = profile.icon;
          name = profile.name;
          terminal = false;
          type = "Application";
        };
      }) profiles
    );

    home.file.".zen/profiles.ini" = {
      text = ''
        ${lib.concatImapStrings (i: profile: ''
          [Profile${toString (i - 1)}]
          Name=${profile.exec}
          IsRelative=1
          Path=${profile.exec}
          ZenAvatarPath=chrome://browser/content/zen-avatars/avatar-63.svg
          Default=${if (profile.default) then "1" else "0"}
        '') cfg.applications.zen-browser.profiles}

        [General]
        StartWithLastProfile=1
        Version=2
      '';
      force = true;
    };
  }) cfg.system.users;
}
