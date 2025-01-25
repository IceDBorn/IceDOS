{
  pkgs,
  config,
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

  pkgMapper =
    pkgList: lists.map (pkgName: foldl' (acc: cur: acc.${cur}) pkgs (splitString "." pkgName)) pkgList;
in
{
  imports = getModules (./modules);

  environment.systemPackages =
    with pkgs;
    [
      efibootmgr # Edit EFI entries
      killall # Tool to kill all programs matching process name
      lazygit # Git TUI
      ncdu # Terminal disk analyzer
      nix-health # Check system health
      nixfmt-rfc-style # A nix formatter
      ntfs3g # Support NTFS drives
      p7zip # 7zip
      unrar # Support opening rar files
      unzip # An extraction utility
      wget # Terminal downloader
    ]
    ++ (pkgMapper cfg.applications.extraPackages);
}
