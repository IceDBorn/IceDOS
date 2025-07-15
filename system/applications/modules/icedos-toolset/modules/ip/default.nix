{
  pkgs,
  ...
}:

let
  command = "ip";
  curl = "${pkgs.curl}/bin/curl";
in
{
  icedos.internals.toolset.commands = [
    {
      bin = "${pkgs.writeShellScript command ''(${curl} ipinfo.io/$(${curl} ifconfig.me)) 2>/dev/null | ${pkgs.jq}/bin/jq''}";
      command = command;
      help = "print current ip info";
    }
  ];
}
