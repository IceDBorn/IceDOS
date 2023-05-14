{ config, pkgs, lib, ... }:

lib.mkIf config.work.user.enable {
	home-manager.users.${config.work.user.username} = {
		programs = {
			git = {
				enable = true;
				# Git config
				userName  = "${config.work.user.github.username}";
				userEmail = "${config.work.user.github.email}";
			};

			kitty = {
				enable = true;
				settings = {
					background_opacity = "0.8";
					confirm_os_window_close = "0";
					cursor_shape = "beam";
					enable_audio_bell = "no";
					hide_window_decorations = "yes";
					update_check_interval = "0";
					copy_on_select = "no";
				};
				font.name = "JetBrainsMono Nerd Font";
				theme = "Catppuccin-Mocha";
			};

			zsh = {
				enable = true;
				# Enable firefox wayland
				profileExtra = "export MOZ_ENABLE_WAYLAND=1";

				# Install powerlevel10k
				plugins = with pkgs; [
					{
						name = "powerlevel10k";
						src = zsh-powerlevel10k;
						file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
					}
					{
						name = "zsh-nix-shell";
						file = "share/zsh-nix-shell/nix-shell.plugin.zsh";
						src = zsh-nix-shell;
					}
				];

				initExtra = ''
					# prevent terminator from remembering commands from other panes
					unset HISTFILE
					# terminator env
					echo $INIT_CMD
					if [ ! -z "$INIT_CMD" ]; then
						OLD_IFS=$IFS
						setopt shwordsplit
						IFS=';'
						for cmd in $INIT_CMD; do
							print -s "$cmd"  # add to history
							eval $cmd
						done
						unset INIT_CMD
						IFS=$OLD_IFS
					fi

					export NVM_DIR="$HOME/.nvm"
					[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
					[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
				'';
			};

			# Install gnome extensions using firefox
			firefox.enableGnomeExtensions = true;
		};

		home.file = {
			# Add zsh theme to zsh directory
			".config/zsh/zsh-theme.zsh" = {
				source = ../configs/zsh-theme.zsh;
				recursive = true;
			};

			# Add arkenfox user.js
			".mozilla/firefox/privacy/user.js" = lib.mkIf config.firefox-privacy.enable {
				source =
				"${(config.nur.repos.slaier.arkenfox-userjs.overrideAttrs (oldAttrs: {
					installPhase = ''
						cat ${../configs/firefox/user-overrides.js} >> user.js
						mkdir -p $out
						cp ./user.js $out/user.js
					'';
				}))}/user.js";
				recursive = true;
			};

			# Set firefox to privacy profile
			".mozilla/firefox/profiles.ini" = lib.mkIf config.firefox-privacy.enable {
				source = ../configs/firefox/profiles.ini;
				recursive = true;
			};

			# Add noise suppression microphone
			".config/pipewire/pipewire.conf.d/99-input-denoising.conf" = {
				source = ../configs/pipewire.conf;
				recursive = true;
			};

			# Add btop config
			".config/btop/btop.conf" = {
				source = ../configs/btop.conf;
				recursive = true;
			};

			# Add kitty session config
			".config/kitty/kitty.session" = {
				source = ../configs/kitty.session;
				recursive = true;
			};

			# Add kitty task managers session config
			".config/kitty/kitty-task-managers.session" = {
				source = ../configs/kitty-task-managers.session;
				recursive = true;
			};

			# Add nvchad
			# ".config/nvim" = {
			# 	source = "${(pkgs.callPackage ../programs/self-built/nvchad.nix {})}";
			# 	recursive = true;
			# };

			# ".config/nvim/lua/custom" = {
			# 	source = ../configs/nvchad;
			# 	recursive = true;
			# 	force = true;
			# };

			# Add tmux config
			# ".config/tmux/tmux.conf" = {
			# 	source = ../configs/tmux.conf;
			# 	recursive = true;
			# };

			# ".config/tmux/tpm" = {
			# 	source = "${(pkgs.callPackage ../programs/self-built/tpm.nix {})}";
			# 	recursive = true;
			# };

			# Add terminator config
			".config/terminator/config" = {
				source = ../configs/terminator;
				recursive = true;
			};
		};
	};
}
