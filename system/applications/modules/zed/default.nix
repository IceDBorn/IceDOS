{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mapAttrs mkIf;
  cfg = config.icedos;
  zed = cfg.applications.zed;
in
mkIf (zed.enable) {
  environment.variables.EDITOR = mkIf (cfg.applications.defaultEditor == "zed") "zeditor -n -w";

  environment.systemPackages = with pkgs; [
    nil
    nixd
    package-version-server
  ];

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
        auto_update = false;
        autosave = "off";
        buffer_font_family = "JetBrainsMono Nerd Font";
        buffer_font_size = 16;
        chat_panel.button = "never";
        collaboration_panel.button = false;
        features.edit_prediction_provider = "none";

        indent_guides = {
          enabled = true;
          coloring = "indent_aware";
        };

        inlay_hints.enabled = true;
        journal.hour_format = "hour24";
        lsp.nil.initialization_options.formatting.command = [ "nixfmt" ];
        notification_panel.button = false;
        relative_line_numbers = true;
        show_whitespaces = "boundary";
        tabs.git_status = true;

        terminal = {
          blinking = "on";
          copy_on_select = true;
          font_family = "JetBrainsMono Nerd Font";
          font_size = 16;
        };

        theme = {
          dark = zed.theme.dark;
          light = zed.theme.light;
          mode = zed.theme.mode;
        };

        ui_font_size = 18;
        vim_mode = zed.vim;
      };
    };
  }) cfg.system.users;
}
