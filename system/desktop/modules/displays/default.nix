{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib)
    concatMapStrings
    head
    mapAttrs
    mkIf
    optional
    sort
    ;

  cfg = config.icedos;
  command = "displays";
  gnome = cfg.desktop.gnome.enable;
  hyprland = cfg.desktop.hyprland.enable;
  tempConfigPath = "/tmp/icedos";
  primaryDisplayPath = "${tempConfigPath}/primary-display";
in
{
  icedos.internals.toolset.commands = mkIf (gnome || hyprland) [
    (
      let
        commands = [
          (
            let
              command = "info";
            in
            {
              bin = "${pkgs.writeShellScript command ''
                ${
                  if (gnome) then
                    ''[ "$XDG_CURRENT_DESKTOP" = "GNOME" ] && "${pkgs.gnome-randr}/bin/gnome-randr"''
                  else
                    ""
                }

                ${
                  if (hyprland) then
                    ''[ "$XDG_CURRENT_DESKTOP" = "Hyprland" ] && "${pkgs.hyprland}/bin/hyprctl" monitors''
                  else
                    ""
                }
              ''}";

              command = command;
              help = "print displays information";
            }
          )
        ]
        ++ optional (cfg.desktop.hyprland.enable) (
          let
            command = "xprimary";
          in
          {
            bin = "${pkgs.writeShellScript command ''
              [ "$XDG_CURRENT_DESKTOP" = "GNOME" ] && echo "error: not supported by gnome" && exit 1

              ACTIVE_MONITORS=($(xrandr --listactivemonitors | grep '+0' | awk '{ print $4 }' | sort))
              TEMP_CONFIG_PATH="${tempConfigPath}"
              PRIMARY_DISPLAY_PATH="${primaryDisplayPath}"

              mkdir -p "$TEMP_CONFIG_PATH"
              echo "Select a display:"

              select monitor in "''${ACTIVE_MONITORS[@]}"; do
                [ "$monitor" != "" ] && echo "$monitor" > "$PRIMARY_DISPLAY_PATH" && exit 0
                echo "error: not a valid selection, try again"
              done
            ''}";

            command = command;
            help = "set primary monitor for xwayland";
          }
        );

        purpleString = string: ''''${PURPLE}${string}''${NC}'';
      in
      {
        bin = "${pkgs.writeShellScript command ''

          PURPLE='\033[0;35m'
          NC='\033[0m'

          if [[ "$1" == "" || "$1" == "help" ]]; then
            echo "Available commands:"

            ${concatMapStrings (tool: ''
              echo -e "> ${purpleString tool.command}: ${tool.help} "
            '') (sort (a: b: a.command < b.command) (commands))}

            exit 0
          fi

          case "$1" in
            ${concatMapStrings (tool: ''
              ${tool.command})
                shift
                exec ${tool.bin} "$@"
                ;;
            '') commands}
            *|-*|--*)
              echo "Unknown arg: $1" >&2
              exit 1
              ;;
          esac
        ''}";

        command = command;
        help = "print displays related commands";
      }
    )
  ];

  home-manager.users = mapAttrs (user: _: {
    systemd.user.services.xprimary = mkIf (cfg.desktop.hyprland.enable) {
      Unit.Description = "X11 primary display watcher";
      Install.WantedBy = [
        "graphical-session.target"
        "hyprland-session.target"
      ];

      Service = {
        ExecStart =
          let
            coreutils = pkgs.coreutils-full;
            echo = "${coreutils}/bin/echo";
            xrandr = "${pkgs.xorg.xrandr}/bin/xrandr";
          in
          "${pkgs.writeShellScript "xprimary" ''
            TEMP_CONFIG_PATH="${tempConfigPath}"
            PRIMARY_DISPLAY_PATH="${primaryDisplayPath}"
            PRIMARY_DISPLAY="${(head (cfg.hardware.monitors)).name}"

            function setPrimaryMonitor () {
              ${echo} "$1" > "$PRIMARY_DISPLAY_PATH"
              ${xrandr} --output "$1" --primary || exit 1
              ${pkgs.libnotify}/bin/notify-send "System" "Set X11 primary display to $1"
              ${echo} "Set X11 primary display to $PRIMARY_DISPLAY"
            }

            setPrimaryMonitor "$PRIMARY_DISPLAY"

            while :; do
              ${coreutils}/bin/sleep 1
              ${coreutils}/bin/mkdir -p "$TEMP_CONFIG_PATH"

              CURRENT_PRIMARY_DISPLAY="$PRIMARY_DISPLAY"
              [ -f "$PRIMARY_DISPLAY_PATH" ] && CURRENT_PRIMARY_DISPLAY=$(${coreutils}/bin/cat "$PRIMARY_DISPLAY_PATH")

              [[ "$CURRENT_PRIMARY_DISPLAY" == "$PRIMARY_DISPLAY" && "$(${xrandr} --current | ${pkgs.gnugrep}/bin/grep primary | ${pkgs.gawk}/bin/awk '{print $1}')" == "$CURRENT_PRIMARY_DISPLAY" ]] && continue

              PRIMARY_DISPLAY="$CURRENT_PRIMARY_DISPLAY"
              setPrimaryMonitor "$PRIMARY_DISPLAY"
            done
          ''}";

        Nice = "-20";
        Restart = "on-failure";
        StartLimitIntervalSec = 60;
        StartLimitBurst = 60;
      };
    };
  }) cfg.system.users;
}
