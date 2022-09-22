{ config, pkgs, home-manager, ... }:
let
    github.username = "CrazyStevenz";
    github.email = "spapanatsios@gmail.com";
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
                        background_opacity = "0.8";
                        confirm_os_window_close = "0";
                        cursor_shape = "underline";
                        cursor_underline_thickness = "1.0";
                        enable_audio_bell = "no";
                        linux_display_server = "x11";
                        update_check_interval = "0";
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
                        cpu_temp = true;
                        engine_color = "FFFFFF";
                        font_size = 20;
                        fps = true;
                        fps_limit = "144+60+0";
                        frame_timing = 0;
                        gamemode = true;
                        gl_vsync = 0;
                        gpu_color = "FFFFFF";
                        gpu_temp = true;
                        no_small_font = true;
                        offset_x = 50;
                        position = "top-right";
                        toggle_fps_limit = "F1";
                        vsync= 1;
                    };
                };

                zsh = {
                    enable = true;
                    # Enable firefox wayland
                    profileExtra = "export MOZ_ENABLE_WAYLAND=1";

                    # Install powerlevel10k
                    plugins = with pkgs; [
                        {
                            name = "powerlevel10k";
                            src = pkgs.zsh-powerlevel10k;
                            file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
                        }
                    ];

                    initExtra = ''eval "$(direnv hook zsh)"'';
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
                        background_opacity = "0.8";
                        confirm_os_window_close = "0";
                        cursor_shape = "underline";
                        cursor_underline_thickness = "1.0";
                        enable_audio_bell = "no";
                        linux_display_server = "x11";
                        update_check_interval = "0";
                    };
                };

                zsh = {
                    enable = true;
                    # Enable firefox wayland
                    profileExtra = "export MOZ_ENABLE_WAYLAND=1";

                    # Install powerlevel10k
                    plugins = with pkgs; [
                        {
                            name = "powerlevel10k";
                            src = pkgs.zsh-powerlevel10k;
                            file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
                        }
                    ];

                    initExtra = ''eval "$(direnv hook zsh)"'';
                };

                # Install gnome extensions using firefox
                firefox.enableGnomeExtensions = true;
            };
        };
    };
}
