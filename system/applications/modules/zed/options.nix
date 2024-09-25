{ config, lib, ... }:

let
  inherit (lib)
    attrNames
    filter
    foldl'
    mkIf
    ;

  cfg = config.icedos;
  mapAttrsAndKeys = callback: list: (foldl' (acc: value: acc // (callback value)) { } list);
in
mkIf (cfg.applications.zed.enable) {
  home-manager.users =
    let
      users = filter (user: cfg.system.users.${user}.enable == true) (attrNames cfg.system.users);
    in
    mapAttrsAndKeys (
      user:
      let
        username = cfg.system.users.${user}.username;
      in
      {
        ${username}.home.file = {
          ".config/zed/settings.json" = {
            text = ''
              {
                ${
                  if (cfg.applications.zed.ollamaSupport) then
                    ''
                      "assistant": {
                        "default_model": {
                          "provider": "ollama",
                          "model": "llama3.1:latest"
                        },
                        "version": "2",
                        "provider": null
                      },
                      "language_models": {
                        "ollama": {
                          "api_url": "http://localhost:11434",
                        },
                      },
                    ''
                  else
                    ""
                }
                "auto_update": false,
                "autosave": "off",
                "buffer_font_family": "JetBrainsMono Nerd Font",
                "buffer_font_size": 14,
                "chat_panel": { "button": false },
                "collaboration_panel": { "button": false },
                "features": { "inline_completion_provider": "none" },
                "notification_panel": { "button": false },
                "terminal": {
                  "blinking": "on",
                  "copy_on_select": true,
                  "font_family": "JetBrainsMono Nerd Font",
                  "font_size": 14,
                },
                "theme": {
                  "dark": "${cfg.applications.zed.theme.dark}",
                  "light": "${cfg.applications.zed.theme.light}",
                  "mode": "${cfg.applications.zed.theme.mode}",
                },
                "indent_guides": {
                  "enabled": true,
                  "coloring": "indent_aware",
                },
                "inlay_hints": { "enabled": true },
                "journal": { "hour_format": "hour24" },
                "relative_line_numbers": true,
                "show_whitespaces": "boundary",
                "tabs": { "git_status": true },
                "ui_font_size": 16,
                "vim_mode": true
              }
            '';

            force = true;
          };
        };
      }
    ) users;
}
