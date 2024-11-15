{ ... }:

{

  programs.hyprlux = {
    enable = true;

    night_light = {
      enabled = true;
      start_time = "21:00";
      end_time = "07:00";
      temperature = 5000;
    };

    vibrance_configs = [
      {
        window_class = "cs2";
        window_title = "";
        strength = 100;
      }
    ];
  };
}
