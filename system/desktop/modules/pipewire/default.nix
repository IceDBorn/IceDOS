{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mapAttrs;
  cfg = config.icedos.system;
in
{
  services = {
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    pulseaudio.enable = false;
  };

  # Enable service which hands out realtime scheduling priority to user processes on demand
  security.rtkit.enable = true;

  environment.systemPackages = with pkgs; [ pwvucontrol ];

  home-manager.users = mapAttrs (user: _: {
    home.file.".config/pipewire/pipewire.conf.d/99-input-denoising.conf".text = ''
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
  }) cfg.users;
}
