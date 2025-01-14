{
  pkgs,
  ...
}:

{
  programs.gamemode = {
    enable = true;

    settings = {
      general.renice = 20;

      gpu = {
        apply_gpu_optimisations = "accept-responsibility";
        nv_powermizer_mode = 1;
        amd_performance_level = "high";
      };

      custom = {
        start = "${pkgs.libnotify}/bin/notify-send 'Gamemode enabled'";
        end = "${pkgs.libnotify}/bin/notify-send 'Gamemode disabled'";
      };
    };
  };
}
