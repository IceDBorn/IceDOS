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
				font.size = 10;
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

			# Add user.js
			".mozilla/firefox/privacy/user.js" = {
        source = if (config.firefox.privacy.enable) then 
          "${(pkgs.callPackage ../programs/self-built/arkenfox-userjs.nix {})}/user.js" 
        else
          ../configs/firefox/user.js;
				recursive = true;
			};

      # Install firefox gnome theme
      ".mozilla/firefox/privacy/chrome/firefox-gnome-theme" = lib.mkIf config.firefox.gnome-theme.enable {
				source = pkgs.callPackage ../programs/self-built/firefox-gnome-theme.nix {};
				recursive = true;
			};

      # Import firefox gnome theme userChrome.css or disable WebRTC indicator
			".mozilla/firefox/privacy/chrome/userChrome.css" = {
        text = if config.firefox.gnome-theme.enable then
          ''@import "firefox-gnome-theme/userChrome.css"''
        else
          ''#webrtcIndicator { display: none }'';
				recursive = true;
			};

      # Import firefox gnome theme userContent.css
			".mozilla/firefox/privacy/chrome/userContent.css" = lib.mkIf config.firefox.gnome-theme.enable {
        text = ''@import "firefox-gnome-theme/userContent.css"'';
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
			".config/tmux/tmux.conf" = {
				source = ../configs/tmux.conf;
				recursive = true;
			};

			".config/tmux/tpm" = {
				source = "${(pkgs.callPackage ../programs/self-built/tpm.nix {})}";
				recursive = true;
			};

			# Add terminator config
			".config/terminator/config" = {
				source = ../configs/terminator;
				recursive = true;
			};
		};
	};
}
