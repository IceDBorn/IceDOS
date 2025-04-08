{
  pkgs,
  ...
}:

let
  package = pkgs.nixfmt-rfc-style;
in
{
  environment.systemPackages = [ package ];

  icedos.internals.toolset.commands = [
    (
      let
        command = "nixf";
      in
      {
        bin = "${pkgs.writeShellScript command ''find "''${1:-.}" -type f -name "*.nix" -exec "${package}/bin/nixfmt" {} \;''}";
        command = command;
        help = "format all nix files of current or provided directory";
      }
    )
  ];
}
