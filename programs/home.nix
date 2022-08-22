{ config, pkgs, home-manager, ... }:
let
    github.username = "IceDBorn";
    github.email = "github.envenomed@dralias.com";
in
{
    home-manager.users = {
        ${config.main.user.username} = {
            programs = {
                git = {
                    enable = true;
                    # Git config
                    userName  = "${github.username}";
                    userEmail = "${github.email}";
                };

                kitty = {
                    enable = true;
                    settings = {
                        cursor_shape = "underline";
                        cursor_underline_thickness = "1.0";
                        background_opacity = "0.8";
                        linux_display_server = "x11";
                        update_check_interval = "0";
                        confirm_os_window_close = "0";
                        enable_audio_bell = "no";
                    };
                };

                mangohud = {
                    enable = true;
                    # MangoHud is started on any application that supports it
                    enableSessionWide = true;
                    # Mangohud config
                    settings = {
                        background_alpha = 0;
                        cpu_color = "FFFFFF";
                        engine_color = "FFFFFF";
                        font_size = 20;
                        fps_limit = "144+60+0";
                        frame_timing = 0;
                        gl_vsync = 0;
                        gpu_color = "FFFFFF";
                        offset_x = 50;
                        position = "top-right";
                        toggle_fps_limit = "F1";
                        vsync= 1;
                        cpu_temp = "";
                        fps = "";
                        gamemode = "";
                        gpu_temp = "";
                        no_small_font = "";
                    };
                };

                zsh = {
                    enable = true;
                    # Enable firefox wayland
                    profileExtra = "export MOZ_ENABLE_WAYLAND=1";
                };

                # Install gnome extensions using firefox
                firefox.enableGnomeExtensions = true;
            };
        };

        ${config.work.user.username} = {
            programs = {
                git = {
                    enable = true;
                    # Git config
                    userName  = "${github.username}";
                    userEmail = "${github.email}";
                };

                kitty = {
                    enable = true;
                    settings = {
                        cursor_shape = "underline";
                        cursor_underline_thickness = "1.0";
                        background_opacity = "0.8";
                        linux_display_server = "x11";
                        update_check_interval = "0";
                        confirm_os_window_close = "0";
                        enable_audio_bell = "no";
                    };
                };

                zsh = {
                    enable = true;
                    # Enable firefox wayland
                    profileExtra = "export MOZ_ENABLE_WAYLAND=1";
                };

                # Install gnome extensions using firefox
                firefox.enableGnomeExtensions = true;
            };
        };
    };
}