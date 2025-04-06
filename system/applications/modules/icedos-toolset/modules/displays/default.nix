{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mkIf;
  cfg = config.icedos;
  command = "displays";
  gnome = cfg.desktop.gnome.enable;
  hyprland = cfg.desktop.hyprland.enable;
in
{
  icedos.internals.toolset.commands = mkIf (gnome || hyprland) [
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
  ];
}
