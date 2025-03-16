{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) makeBinPath mapAttrs;
  cfg = config.icedos;
in
{
  home-manager.users = mapAttrs (
    user: _:
    let
      startupScript = cfg.system.users.${user}.desktop.gnome.startupScript;
    in
    {
      home.file = {
        ".config/autostart/gnome-startup.desktop" = {
          text = ''
            [Desktop Entry]
            Exec=${
              makeBinPath [
                (pkgs.writeShellScriptBin "gnome-startup" ''
                  run () {
                    pidof $1 || "$@" &
                  }

                  ${startupScript}
                '')
              ]
            }/gnome-startup
            Icon=kitty
            Name=StartupScript
            StartupWMClass=startup
            Terminal=false
            Type=Application
          '';
        };
      };
    }
  ) cfg.system.users;
}
