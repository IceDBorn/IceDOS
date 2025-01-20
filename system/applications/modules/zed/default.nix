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
mkIf (cfg.applications.zed.enable) {
  environment.variables.EDITOR = mkIf (cfg.applications.defaultEditor == "zed") "zeditor -n -w";

  environment.systemPackages = with pkgs; [
    nil
    nixd
    package-version-server
  ];

  services.ollama.enable = cfg.applications.zed.ollamaSupport;

  home-manager.users = mapAttrs (user: _: {
    programs.zed-editor = {
      enable = true;

      extensions = [
        "git-firefly"
        "html"
        "nix"
        "one-dark-pro"
        "php"
        "sql"
        "toml"
        "twig"
      ];

      userSettings = {
        assistant = mkIf (cfg.applications.zed.ollamaSupport) {
          default_model = {
            provider = "ollama";
            model = "llama3.1:latest";
          };

          version = 2;
          provider = "null";
        };

        auto_update = false;
        autosave = "off";
        buffer_font_family = "JetBrainsMono Nerd Font";
        buffer_font_size = 14;
        chat_panel.button = false;
        collaboration_panel.button = false;
        features.inline_completion_provider = "none";

        indent_guides = {
          enabled = true;
          coloring = "indent_aware";
        };

        inlay_hints.enabled = true;
        journal.hour_format = "hour24";
        language_models.ollama.api_url = "http://localhost:11434";
        lsp.nil.initialization_options.formatting.command = [ "nixfmt" ];
        notification_panel.button = false;
        relative_line_numbers = true;
        show_whitespaces = "boundary";
        tabs.git_status = true;

        terminal = {
          blinking = "on";
          copy_on_select = true;
          font_family = "JetBrainsMono Nerd Font";
          font_size = 14;
        };

        theme = {
          dark = cfg.applications.zed.theme.dark;
          light = cfg.applications.zed.theme.light;
          mode = cfg.applications.zed.theme.mode;
        };

        ui_font_size = 16;
        vim_mode = cfg.applications.zed.vim;
      };
    };
  }) cfg.system.users;
}
