{
  config,
  lib,
  pkgs,
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

  extraPackages = [
    pkgs.gamescope
    gamescope-launch
  ];

  package = pkgs.gamescope;

  gamescope-launch = (
    pkgs.writeShellScriptBin "gamescope-launch" ''
      GAMESCOPE="${pkgs.scopebuddy}/bin/scopebuddy"
      GAMEMODE="${pkgs.gamemode}/bin/gamemoderun"
      SDL="--backend sdl"

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
          --no-sdl)
            SDL=""
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

      SCB_GAMESCOPE_ARGS="$DEFAULT_WIDTH $DEFAULT_HEIGHT $DEFAULT_REFRESH_RATE $SDL $MANGOHUD $GAMESCOPE_ARGS"

      export SCB_GAMESCOPE_ARGS

      $GAMEMODE $GAMESCOPE -- "''${COMMAND[@]}"
    ''
  );

  ifSteam = deck: cfg.applications.steam.enable && deck;
in
{
  environment.systemPackages = [
    gamescope-launch
    package
  ];

  icedos.internals.toolset.commands = [
    (
      let
        command = "gamescope-launch";
      in
      {
        bin = "${gamescope-launch}/bin/${command}";
        command = command;
        help = "launch exec using gamescope with optimal usage flags";
      }
    )
  ];

  programs.steam.extraPackages = mkIf (ifSteam (cfg.hardware.devices.steamdeck)) extraPackages;

  home-manager.users = mapAttrs (user: _: {
    home.packages = mkIf (ifSteam (!cfg.hardware.devices.steamdeck)) [
      (pkgs.steam.override { extraPkgs = pkgs: extraPackages; })
    ];
  }) cfg.system.users;
}
