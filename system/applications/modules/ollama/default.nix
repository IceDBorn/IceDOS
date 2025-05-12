{
  config,
  lib,
  ...
}:

let
  inherit (lib)
    head
    length
    mapAttrs
    mkIf
    ;

  cfg = config.icedos;
  ollama = cfg.applications.ollama;
in
mkIf (ollama.enable) {
  services.ollama = {
    enable = true;
    rocmOverrideGfx = ollama.rocmOverrideGfx;
    loadModels = ollama.models;
  };

  home-manager.users = mapAttrs (user: _: {
    programs.zed-editor = mkIf (cfg.applications.zed.enable) {
      userSettings = mkIf (ollama.enable) {
        assistant = {
          default_model = {
            provider = "ollama";
            model = if (length ollama.models != 0) then "${head (ollama.models)}" else "";
          };

          version = 2;
        };

        language_models = {
          ollama = {
            api_url = "http://localhost:11434";
            available_models = map (model: {
              name = "${model}";
              display_name = "${model}";
              max_tokens = 32768;
            }) (ollama.models);
          };
        };
      };
    };
  }) cfg.system.users;
}
