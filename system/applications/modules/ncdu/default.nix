{
  pkgs,
  ...
}:

{
  icedos.internals.toolset.commands = [
    (
      let
        command = "du";
      in
      {
        bin = "${pkgs.writeShellScript command ''${pkgs.ncdu}/bin/ncdu "$@"''}";
        command = command;
        help = "see disk usage on current folder or provided path";
      }
    )
  ];
}
