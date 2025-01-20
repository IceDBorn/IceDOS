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
mkIf (cfg.applications.codium.enable) {
  environment.variables.EDITOR = mkIf (cfg.applications.defaultEditor == "codium") "codium -n -w";

  home-manager.users = mapAttrs (user: _: {
    programs.vscode = {
      enable = true;
      enableExtensionUpdateCheck = false;
      enableUpdateCheck = false;
      package = pkgs.vscodium;

      extensions = with pkgs; [
        vscode-extensions.codezombiech.gitignore
        vscode-extensions.dbaeumer.vscode-eslint
        vscode-extensions.donjayamanne.githistory
        vscode-extensions.eamodio.gitlens
        vscode-extensions.editorconfig.editorconfig
        vscode-extensions.esbenp.prettier-vscode
        vscode-extensions.fabiospampinato.vscode-open-in-github
        vscode-extensions.formulahendry.auto-close-tag
        vscode-extensions.formulahendry.code-runner
        vscode-extensions.gruntfuggly.todo-tree
        vscode-extensions.jnoortheen.nix-ide
        vscode-extensions.pkief.material-icon-theme
        vscode-extensions.tamasfe.even-better-toml
        vscode-extensions.timonwong.shellcheck
        vscode-extensions.zhuangtongfa.material-theme
      ];

      userSettings = {
        "[css]".editor.defaultFormatter = "esbenp.prettier-vscode";
        "[javascript]".editor.defaultFormatter = "esbenp.prettier-vscode";
        "[typescript]".editor.defaultFormatter = "esbenp.prettier-vscode";
        "[typescriptreact]".editor.defaultFormatter = "esbenp.prettier-vscode";
        diffEditor.ignoreTrimWhitespace = false;
        editor.fontFamily = "'JetBrainsMono Nerd Font', 'Droid Sans Mono', 'monospace', monospace";
        editor.fontLigatures = true;
        editor.formatOnPaste = cfg.system.users.${user}.applications.codium.formatOnPaste;
        editor.formatOnSave = cfg.system.users.${user}.applications.codium.formatOnSave;
        editor.minimap.enabled = false;
        editor.renderWhitespace = "trailing";
        editor.smoothScrolling = true;
        editor.tabSize = 2;
        evenBetterToml.formatter.alignComments = false;
        files.associations."*.css" = "tailwindcss";
        files.autoSave = cfg.system.users.${user}.applications.codium.autoSave;
        files.insertFinalNewline = true;
        files.trimFinalNewlines = true;
        files.trimTrailingWhitespace = true;
        git.autofetch = true;
        git.confirmSync = false;
        gitlens.codeLens.enabled = false;
        gitlens.defaultDateFormat = "YYYY-MM-DD HH:mm";
        gitlens.defaultDateLocale = "system";
        gitlens.defaultDateShortFormat = "YYYY-M-D";
        gitlens.defaultTimeFormat = "HH:mm";
        gitlens.statusBar.enabled = false;
        gitlens.views.repositories.showContributors = false;
        gitlens.views.repositories.showStashes = true;
        gitlens.views.repositories.showTags = false;
        gitlens.views.repositories.showWorktrees = false;
        intelephense.environment.phpVersion = "7.4.3";
        intelephense.format.braces = "k&r";
        nix.formatterPath = "nixfmt";
        scm.showHistoryGraph = false;

        terminal.integrated = {
          cursorBlinking = true;
          cursorStyle = "line";
          smoothScrolling = true;
        };

        update.mode = "none";
        window.menuBarVisibility = "toggle";
        window.zoomLevel = cfg.applications.codium.zoomLevel;

        workbench = {
          colorTheme = "One Dark Pro Darker";
          iconTheme = "material-icon-theme";
          list.smoothScrolling = true;
          startupEditor = "none";
          tips.enabled = false;
        };
      };
    };
  }) cfg.system.users;
}
