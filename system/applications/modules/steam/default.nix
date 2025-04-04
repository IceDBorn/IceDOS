{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib)
    head
    last
    mapAttrs
    mkIf
    splitString
    ;

  cfg = config.icedos;

  gamescope-launch = (
    pkgs.writeShellScriptBin "gamescope-launch" ''
      OG_LD_PRELOAD="$LD_PRELOAD"
      LD_PRELOAD=""
      GAMEMODE="gamemoderun"

      ${
        if (cfg.applications.mangohud.enable) then
          ''
            MANGOHUD="--mangoapp"
            MANGOHUD_CONFIGFILE="/home/$USER/.config/MangoHud/MangoHud.conf"
          ''
        else
          ""
      }

      ${
        let
          monitor = head (cfg.hardware.monitors);
          resolution = splitString "x" (monitor.resolution);
          width = head (resolution);
          height = last (resolution);
          refreshRate = toString (monitor.refreshRate);
        in
        ''
          DEFAULT_WIDTH="-W ${width}"
          DEFAULT_HEIGHT="-H ${height}"
          DEFAULT_REFRESH_RATE="-r ${refreshRate}"
        ''
      }

      while [[ $# -gt 0 ]]; do
        case "$1" in
          --gamescope-args)
            GAMESCOPE_ARGS="$2"

            if [[ $GAMESCOPE_ARGS = *'-W'* ]] || [[ $GAMESCOPE_ARGS = *'-H'* ]]; then
                DEFAULT_WIDTH=""
                DEFAULT_HEIGHT=""
            fi

            if [[ $GAMESCOPE_ARGS = *'-r'* ]]; then
                DEFAULT_REFRESH_RATE=""
            fi

            shift 2
            ;;
          --no-gamemode)
            GAMEMODE=""
            shift
            ;;
          --no-mangohud)
            MANGOHUD=""
            shift
            ;;
          --)
            shift
            COMMAND=("$@")
            break
            ;;
          *)
            COMMAND=("$@")
            break
            ;;
          -*|--*)
            echo "Unknown arg: $1" >&2
            exit 1
            ;;
        esac
      done

      DEFAULT_GAMESCOPE_ARGS="$DEFAULT_WIDTH $DEFAULT_HEIGHT $DEFAULT_REFRESH_RATE"

      $GAMEMODE gamescope $MANGOHUD $DEFAULT_GAMESCOPE_ARGS $GAMESCOPE_ARGS -- env LD_PRELOAD="$OG_LD_PRELOAD" "''${COMMAND[@]}"
    ''
  );

  extraPackages = [
    pkgs.gamescope
    gamescope-launch
  ];
in
mkIf (cfg.applications.steam.enable) {
  home-manager.users = mapAttrs (
    user: _:
    let
      type = cfg.system.users.${user}.type;
    in
    {
      home = {
        file = {
          # Enable steam beta
          ".local/share/Steam/package/beta" = mkIf (type != "work" && cfg.applications.steam.beta) {
            text = if (cfg.applications.steam.session.enable) then "steamdeck_publicbeta" else "publicbeta";
          };

          # Enable slow steam downloads workaround
          ".local/share/Steam/steam_dev.cfg" =
            mkIf (type != "work" && cfg.applications.steam.downloadsWorkaround)
              {
                text = ''
                  @nClientDownloadEnableHTTP2PlatformLinux 0
                  @fDownloadRateImprovementToAddAnotherConnection 1.0
                '';
              };
        };

        packages =
          with pkgs;
          mkIf (!cfg.hardware.devices.steamdeck) [
            (steam.override {
              extraPkgs = pkgs: extraPackages;
            })
          ];
      };
    }
  ) cfg.system.users;

  programs.steam = mkIf (cfg.hardware.devices.steamdeck) {
    enable = true;
    extest.enable = true;
    extraPackages = extraPackages;
  };
}
