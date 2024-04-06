{
  lib,
  config,
  pkgs,
  ...
}:

let
  inherit (lib) attrNames filter foldl';

  cfg = config.icedos.system.user;

  mapAttrsAndKeys = callback: list: (foldl' (acc: value: acc // (callback value)) { } list);
in
{
  home-manager.users =
    let
      users = filter (user: cfg.${user}.enable == true) (attrNames cfg);
    in
    mapAttrsAndKeys (
      user:
      let
        username = cfg.${user}.username;
      in
      {
        ${username}.home.file.".config/pipewire/pipewire.conf.d/99-input-denoising.conf".text = ''
          context.modules = [
            {
              name = libpipewire-module-filter-chain
              args = {
                node.description =  "Noise Canceling source"
                media.name =  "Noise Canceling source"
                filter.graph = {
                  nodes = [
                    {
                      type = ladspa
                      name = rnnoise
                      plugin = ${pkgs.rnnoise-plugin}/lib/ladspa/librnnoise_ladspa.so
                      label = noise_suppressor_mono
                      control = {
                        "VAD Threshold (%)" 95.0
                        "VAD Grace Period (ms)" 200
                        "Retroactive VAD Grace (ms)" 0
                      }
                    }
                  ]
                }
                capture.props = {
                  node.name =  "capture.rnnoise_source"
                  node.passive = true
                  audio.rate = 48000
                }
                playback.props = {
                  node.name =  "rnnoise_source"
                  media.class = Audio/Source
                  audio.rate = 48000
                }
              }
            }
          ]
        '';
      }
    ) users;
}
