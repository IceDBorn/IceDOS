{
  pkgs,
  config,
  inputs,
  lib,
  ...
}:

let
  inherit (lib)
    filterAttrs
    foldl'
    lists
    splitString
    ;

  cfg = config.icedos;

  getModules =
    path:
    builtins.map (dir: ./. + ("/modules/" + dir)) (
      builtins.attrNames (
        filterAttrs (n: v: v == "directory" && !(n == "zen-browser")) (builtins.readDir path)
      )
    );

  pkgFile = lib.importTOML ./packages.toml;

  pkgMapper =
    pkgList: lists.map (pkgName: foldl' (acc: cur: acc.${cur}) pkgs (splitString "." pkgName)) pkgList;
in
{
  imports = getModules (./modules);
  environment.systemPackages =
    (pkgMapper pkgFile.packages) ++ (pkgMapper cfg.applications.extraPackages);
}
