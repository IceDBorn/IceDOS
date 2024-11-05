{
  lib,
  config,
  pkgs,
  ...
}:

let
  inherit (lib) mapAttrs;
  cfg = config.icedos;
in
{
  environment.systemPackages = [ pkgs.wleave ];

  home-manager.users = mapAttrs (user: _: {
    home.file = {
      ".config/wleave/style.css".text = ''
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

      ".config/wleave/layout" = {
        source = ./layout;
      };
    };
  }) cfg.system.users;
}
