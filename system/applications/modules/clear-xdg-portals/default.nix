{
  pkgs,
  ...
}:

let
  command = "clear-xdg-portals";
in
{
  config.icedos.internals.toolset.commands = [
    {
      bin = "${pkgs.writeShellScript command ''
        PORTAL="xdg-desktop-portal"

        rm -rf "$HOME/.config/$PORTAL"
        rm -rf "$HOME/.cache/$PORTAL"
        sudo rm -rf "/etc/xdg/$PORTAL"
        sudo rm -rf "/usr/share/$PORTAL"
      ''}";

      command = command;
      help = "removes all xdg portal files";
    }
  ];
}
