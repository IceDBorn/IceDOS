{ config, pkgs, ... }:
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
						background_opacity = "0.8";
						confirm_os_window_close = "0";
						cursor_shape = "underline";
						cursor_underline_thickness = "1.0";
						enable_audio_bell = "no";
						hide_window_decorations = "yes";
						update_check_interval = "0";
					};
					font.name = "Jetbrains Mono";
				};

				mangohud = {
					enable = true;
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
						{
							name = "zsh-nix-shell";
							file = "share/zsh-nix-shell/nix-shell.plugin.zsh";
							src = pkgs.zsh-nix-shell;
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
						hide_window_decorations = "yes";
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
						{
							name = "zsh-nix-shell";
							file = "share/zsh-nix-shell/nix-shell.plugin.zsh";
							src = pkgs.zsh-nix-shell;
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
