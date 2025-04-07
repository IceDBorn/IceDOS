{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) concatMapStrings mkIf sort;
  cfg = config.icedos;
  command = "displays";
  gnome = cfg.desktop.gnome.enable;
  hyprland = cfg.desktop.hyprland.enable;
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
                    ''[ "$XDG_CURRENT_DESKTOP" = "Gnome" ] && "${pkgs.gnome-randr}/bin/gnome-randr"''
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

          (
            let
              command = "xprimary";
            in
            {
              bin = "${pkgs.writeShellScript command ''
                ACTIVE_MONITORS=($(xrandr --listactivemonitors | grep '+0' | awk '{ print $4 }' | sort))

                echo "Select a display:"

                select monitor in "''${ACTIVE_MONITORS[@]}"; do
                  [ "$monitor" != "" ] && xrandr --output "$monitor" --primary && echo "Set primary monitor to $monitor" && exit 0
                  echo "error: not a valid selection, try again"
                done
              ''}";

              command = command;
              help = "set primary monitor for xwayland";
            }
          )
        ];

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
}
