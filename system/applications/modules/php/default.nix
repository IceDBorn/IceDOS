{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mapAttrs mkIf;
  cfg = config.icedos;
in
mkIf (cfg.applications.php) {
  environment.systemPackages = with pkgs; [
    intelephense # Language server
    php # An HTML-embedded scripting language
    phpPackages.composer # Dependency Manager
    phpPackages.phpstan # Static Analysis Tool
  ];

  home-manager.users = mapAttrs (user: _: {
    programs.vscode.profiles.default = mkIf (cfg.applications.codium.enable) {
      extensions = [ pkgs.vscode-extensions.bmewburn.vscode-intelephense-client ];
      userSettings.intelephense.format.braces = "k&r";
    };

    programs.zed-editor.userSettings = mkIf (cfg.applications.zed.enable) {
      languages.PHP.language_servers = [
        "intelephense"
        "!phpactor"
      ];

      lsp.intelephense.settings.format.braces = "k&r";
    };
  }) cfg.system.users;
}
