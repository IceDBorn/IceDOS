{
  pkgs,
  ...
}:

let
  command = "logout";
in
{
  config.icedos.internals.toolset.commands = [
    {
      bin = "${pkgs.writeShellScript command "pkill -KILL -u $USER"}";
      command = command;
      help = "force kills all current user processes";
    }
  ];
}
