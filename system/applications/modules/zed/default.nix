{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mkIf;
  cfg = config.icedos.applications;
in
{
  imports = [ ./options.nix ];
  environment.variables.EDITOR = mkIf (cfg.zed.enable && cfg.defaultEditor == "zed") "zeditor -n -w";

  environment.systemPackages =
    with pkgs;
    mkIf (cfg.zed.enable) [
      lazygit
      nil
      nixd
      package-version-server
      zed-editor
    ];

  services.ollama.enable = cfg.zed.ollamaSupport;
}
