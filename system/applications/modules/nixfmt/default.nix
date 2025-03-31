{
  pkgs,
  ...
}:

let
  package = pkgs.nixfmt-rfc-style;
in
{
  environment.systemPackages = [
    package
    (pkgs.writeShellScriptBin "nixfmt-dir" ''find "''${1:-.}" -type f -name "*.nix" -exec "${package}/bin/nixfmt" {} \;'')
  ];
}
