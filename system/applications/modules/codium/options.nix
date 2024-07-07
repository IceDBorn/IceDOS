{ config, lib, ... }:
let
  inherit (lib)
    attrNames
    boolToString
    filter
    foldl'
    mkIf
    ;

  cfg = config.icedos;

  mapAttrsAndKeys = callback: list: (foldl' (acc: value: acc // (callback value)) { } list);
in
mkIf (cfg.applications.codium.enable) {
  home-manager.users =
    let
      users = filter (user: cfg.system.users.${user}.enable == true) (attrNames cfg.system.users);
    in
    mapAttrsAndKeys (
      user:
      let
        username = cfg.system.users.${user}.username;

        settings = ''
          {
            "[css]": {
              "editor.defaultFormatter": "esbenp.prettier-vscode"
            },
            "[javascript]": {
              "editor.defaultFormatter": "esbenp.prettier-vscode"
            },
            "diffEditor.ignoreTrimWhitespace": false,
            "editor.fontFamily": "'JetBrainsMono Nerd Font', 'Droid Sans Mono', 'monospace', monospace",
            "editor.fontLigatures": true,
            "editor.formatOnPaste": ${
              boolToString (cfg.system.users.${user}.applications.codium.formatOnPaste)
            },
            "editor.formatOnSave": ${
              boolToString (cfg.system.users.${user}.applications.codium.formatOnSave)
            },
            "editor.minimap.enabled": false,
            "editor.renderWhitespace": "trailing",
            "editor.smoothScrolling": true,
            "editor.tabSize": 2,
            "evenBetterToml.formatter.alignComments": false,
            "files.autoSave": "${cfg.system.users.${user}.applications.codium.autoSave}",
            "files.insertFinalNewline": true,
            "files.trimFinalNewlines": true,
            "files.trimTrailingWhitespace": true,
            "git.autofetch": true,
            "git.confirmSync": false,
            "gitlens.codeLens.enabled": false,
            "gitlens.defaultDateFormat": "YYYY-MM-DD HH:mm",
            "gitlens.defaultDateLocale": "system",
            "gitlens.defaultDateShortFormat": "YYYY-M-D",
            "gitlens.defaultTimeFormat": "HH:mm",
            "gitlens.statusBar.enabled": false,
            "nix.formatterPath": "nixfmt",
            "terminal.integrated.cursorBlinking": true,
            "terminal.integrated.cursorStyle": "line",
            "terminal.integrated.smoothScrolling": true,
            "update.mode": "none",
            "window.menuBarVisibility": "toggle",
            "window.zoomLevel": ${builtins.toString (cfg.applications.codium.zoomLevel)},
            "workbench.colorTheme": "One Dark Pro Darker",
            "workbench.iconTheme": "material-icon-theme",
            "workbench.list.smoothScrolling": true,
            "workbench.startupEditor": "none",
            "workbench.tips.enabled": false
          }
        '';
      in
      {
        ${username}.home.file = {
          ".config/VSCodium/User/settings.json".text = settings;
          ".config/VSCodiumIDE/User/settings.json".text = settings;
        };
      }
    ) users;
}
