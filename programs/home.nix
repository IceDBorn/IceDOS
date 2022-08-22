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

                alacritty = {
                    enable = true;
                    # Alacritty config
                    settings = {
                        window = {
                            # Disabled until material shell is fixed
                            #decorations = "none";
                            decorations = "full";
                        };

                        cursor.style = {
                            shape = "Underline";
                            blinking = "Always";
                        };
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

                alacritty = {
                    enable = true;
                    # Alacritty config
                    settings = {
                        window = {
                            # Disabled until material shell is fixed
                            #decorations = "none";
                            decorations = "full";
                        };

                        cursor.style = {
                            shape = "Underline";
                            blinking = "Always";
                        };
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