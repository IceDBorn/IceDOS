{ config, lib, ... }:
let
  inherit (lib) attrNames filter foldl';

  cfg = config.icedos;

  mapAttrsAndKeys = callback: list: (foldl' (acc: value: acc // (callback value)) { } list);
in
{
  home-manager.users =
    let
      users = filter (user: cfg.system.user.${user}.enable == true) (attrNames cfg.system.user);
    in
    mapAttrsAndKeys (
      user:
      let
        username = cfg.system.user.${user}.username;

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
            "editor.formatOnPaste": ${cfg.system.user.${user}.applications.codium.formatOnPaste},
            "editor.formatOnSave": ${cfg.system.user.${user}.applications.codium.formatOnSave},
            "editor.minimap.enabled": false,
            "editor.renderWhitespace": "trailing",
            "editor.smoothScrolling": true,
            "editor.tabSize": 2,
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
