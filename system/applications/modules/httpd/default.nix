{
  config,
  lib,
  ...
}:

let
  inherit (lib) mapAttrs mkIf;
  cfg = config.icedos;
in
mkIf (cfg.applications.httpd.enable) {
  services.httpd = {
    enable = true;
    user = cfg.applications.httpd.user;
    enablePHP = cfg.applications.httpd.php.enable;
  };

  home-manager.users = mapAttrs (user: _: {
    programs.vscode.profiles.default.userSettings.intelephense.environment.phpVersion = mkIf (
      cfg.applications.codium.enable && cfg.applications.httpd.php.enable
    ) cfg.applications.httpd.php.version;

    programs.zed-editor.userSettings.lsp.intelephense.settings.environment.phpVersion = mkIf (
      cfg.applications.zed.enable && cfg.applications.httpd.php.enable
    ) cfg.applications.httpd.php.version;
  }) cfg.system.users;
}
