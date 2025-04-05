{
  pkgs,
  ...
}:

{
  icedos.internals.toolset.commands = [
    (
      let
        command = "health";
      in
      {
        bin = "${pkgs.writeShellScript command ''"${pkgs.nix-health}/bin/nix-health" -q "$@"''}";

        command = command;
        help = "print information about system state";
      }
    )
  ];
}
