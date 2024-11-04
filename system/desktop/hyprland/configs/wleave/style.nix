{
  lib,
  config,
  pkgs,
  ...
}:

let
  inherit (lib)
    attrNames
    filter
    foldl'
    mkIf
    ;

  mapAttrsAndKeys = callback: list: (foldl' (acc: value: acc // (callback value)) { } list);

  cfg = config.icedos;
in
{
  home-manager.users =
    let
      users = attrNames cfg.system.users;
    in
    mapAttrsAndKeys (
      user:
      {
        ${user} = mkIf (cfg.desktop.hyprland.enable) {
          home.file.".config/wleave/style.css".text = ''
            * {
              background-image: none;
            }

            window {
              background-color: rgba(12, 12, 12, 0.5);
            }

            button {
              color: #FBFBFB;
              background-color: #1E1E1E;
              background-repeat: no-repeat;
              background-position: center;
              border-radius: 20px;
            }

            button:focus, button:active, button:hover {
              background-color: #2A2A2A;
              outline-style: none;
            }

            #lock {
              background-image: image(url("${pkgs.wleave}/share/wleave/icons/lock.svg"));
            }

            #logout {
              background-image: image(url("${pkgs.wleave}/share/wleave/icons/logout.svg"));
            }

            #suspend {
              background-image: image(url("${pkgs.wleave}/share/wleave/icons/suspend.svg"));
            }

            #hibernate {
              background-image: image(url("${pkgs.wleave}/share/wleave/icons/hibernate.svg"));
            }

            #shutdown {
              background-image: image(url("${pkgs.wleave}/share/wleave/icons/shutdown.svg"));
            }

            #reboot {
              background-image: image(url("${pkgs.wleave}/share/wleave/icons/reboot.svg"));
            }
          '';
        };
      }
    ) users;
}
