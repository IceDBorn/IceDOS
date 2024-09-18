{
  config,
  lib,
  ...
}:

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
mkIf (cfg.applications.mangohud.enable) {
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
        ${username} = {
          programs.mangohud = {
            enable = (user != "server" && user != "work");

            settings = {
              background_alpha = 0;
              battery = (cfg.hardware.devices.laptop || cfg.hardware.devices.steamdeck);
              battery_icon = (cfg.hardware.devices.laptop || cfg.hardware.devices.steamdeck);
              battery_time = (cfg.hardware.devices.laptop || cfg.hardware.devices.steamdeck);
              cpu_color = "FFFFFF";
              cpu_power = true;
              cpu_temp = true;
              engine_color = "FFFFFF";
              engine_short_names = true;
              font_size = 18;
              fps_color = "FFFFFF";
              fps_limit = "${builtins.toString (cfg.applications.mangohud.maxFpsLimit)},60,0";
              frame_timing = false;
              frametime = false;
              gl_vsync = 0;
              gpu_color = "FFFFFF";
              gpu_power = true;
              gpu_temp = true;
              horizontal = true;
              hud_compact = true;
              hud_no_margin = true;
              no_small_font = true;
              offset_x = 5;
              offset_y = 5;
              text_color = "FFFFFF";
              toggle_fps_limit = "Ctrl_L+Shift_L+F1";
              vram_color = "FFFFFF";
              vsync = 1;
            };
          };
        };
      }
    ) users;
}
