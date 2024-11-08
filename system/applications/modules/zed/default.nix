{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mkIf;
  cfg = config.icedos.applications.zed;
in
{
  imports = [ ./options.nix ];
  environment.variables.EDITOR = mkIf (cfg.enable && cfg.defaultEditor) "zeditor -n -w";

  environment.systemPackages =
    with pkgs;
    mkIf (cfg.enable) [
      nixd
      package-version-server
      pkgs.lazygit
      zed-editor
    ];

  services.ollama.enable = cfg.ollamaSupport;
}
