{
  pkgs,
  ...
}:

let
  command = "reboot";
in
{
  icedos.internals.toolset.commands = [
    {
      bin = "${pkgs.writeShellScript command "systemctl reboot -i"}";
      command = command;
      help = "reboot ignoring inhibitors and users";
    }
  ];
}
