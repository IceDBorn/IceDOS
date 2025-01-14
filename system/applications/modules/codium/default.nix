{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib)
    filterAttrs
    mapAttrs
    mkIf
    ;

  cfg = config.icedos;

  getModules =
    path:
    builtins.map (dir: ./. + ("/modules/" + dir)) (
      builtins.attrNames (
        filterAttrs (n: v: v == "directory" && !(n == "zen-browser")) (builtins.readDir path)
      )
    );
in
{
  imports = getModules (./modules);
  environment.systemPackages = with pkgs; mkIf (cfg.applications.codium.enable) [ vscodium ];

  environment.variables.EDITOR = mkIf (
    cfg.applications.codium.enable && cfg.applications.defaultEditor == "codium"
  ) "codium -n -w";

  home-manager.users = mapAttrs (user: _: {
    # Codium profile used as an IDE
    xdg.desktopEntries.codiumIDE = mkIf (cfg.applications.codium.enable) {
      exec = "codium --user-data-dir ${cfg.system.home}/${user}/.config/VSCodiumIDE";
      icon = "codium";
      name = "VSCodium IDE";
      terminal = false;
      type = "Application";
    };
  }) cfg.system.users;
}
