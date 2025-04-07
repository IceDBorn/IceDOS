{
  pkgs,
  ...
}:

let
  command = "ip";
in
{
  icedos.internals.toolset.commands = [
    {
      bin = "${pkgs.writeShellScript command ''"${pkgs.curl}/bin/curl" ifconfig.me''}";
      command = command;
      help = "print current ip";
    }
  ];
}
