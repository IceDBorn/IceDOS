{
  programs.gamemode = {
    enable = true;

    settings = {
      general.renice = 20;
      gpu = {
        apply_gpu_optimisations = 1;
        nv_powermizer_mode = 1;
        amd_performance_level = "high";
      };
    };
  };
}
