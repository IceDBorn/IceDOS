### PACKAGES INSTALLED ON ALL USERS ###
{ pkgs, config, ... }:

let
	trim-generations =  pkgs.writeShellScriptBin "trim-generations" (builtins.readFile ../scripts/trim-generations.sh);
	nix-gc = pkgs.writeShellScriptBin "nix-gc" ''
		trim-generations 10 0 user ;
		trim-generations 10 0 home-manager ;
		sudo runuser - ${config.work.user.username} -c 'trim-generations 10 0 user' ;
		sudo runuser - ${config.work.user.username} -c 'trim-generations 10 0 home-manager' ;
		sudo trim-generations 10 0 system ;
		nix-store --gc
	'';
  vpn-exclude = pkgs.writeShellScriptBin "vpn-exclude" (builtins.readFile ../scripts/create-ns.sh);
in
{
	boot.kernelPackages = pkgs.linuxPackages_zen; # Use ZEN linux kernel

	environment.systemPackages = with pkgs; [
		#(callPackage ./self-built/system-monitoring-center.nix { buildPythonApplication = pkgs.python3Packages.buildPythonApplication; fetchPypi = pkgs.python3Packages.fetchPypi; pygobject3 = pkgs.python3Packages.pygobject3; }) # Task manager
		(callPackage ./self-built/apx.nix {}) # Package manager using distrobox
		(callPackage ./self-built/webcord {}) # An open source discord client
		(firefox.override { extraNativeMessagingHosts = [ (callPackage ./self-built/pipewire-screenaudio {}) ]; }) # Browser
		(pkgs.wrapOBS {plugins = with pkgs.obs-studio-plugins; [ obs-pipewire-audio-capture ];}) # Pipewire audio plugin for OBS Studio
		android-tools # Tools for debugging android devices
		appimage-run # Appimage runner
		aria # Terminal downloader with multiple connections support
		bat # Better cat command
		btop # System monitor
    bless # HEX Editor
		cargo # Rust package manager
		curtail # Image compressor
		direnv # Unclutter your .profile
		efibootmgr # Edit EFI entries
		feh # Minimal image viewer
		gcc # C++ compiler
		gimp # Image editor
		git # Distributed version control system
		gping # ping with a graph
		helvum # Pipewire patchbay
		jq # JSON parser
		killall # Tool to kill all programs matching process name
		kitty # Terminal
		libnotify # Send desktop notifications
		lsd # Better ls command
		mousai # Song recognizer
		mpv # Video player
		mullvad-vpn # VPN Client
		neovim # Terminal text editor
		nix-gc # Garbage collect old nix generations
		nodejs # Node package manager
		ntfs3g # Support NTFS drives
		obs-studio # Recording/Livestream
		onlyoffice-bin # Microsoft Office alternative for Linux
		p7zip # 7zip
		pulseaudio # Various pulseaudio tools
		python3 # Python
		ranger # Terminal file manager
		rnnoise-plugin # A real-time noise suppression plugin
		signal-desktop # Encrypted messaging platform
		sublime4 # Text editor
		tmux # Terminal multiplexer
		tree # Display folder content at a tree format
		trim-generations # Smarter old nix generations cleaner
		unrar # Support opening rar files
		vscodium # All purpose IDE
		warp # File sync
		wget # Terminal downloader
		wine # Compatibility layer capable of running Windows applications
		winetricks # Wine prefix settings manager
		woeusb # Windows ISO Burner
		xorg.xhost # Use x.org server with distrobox
		youtube-dl # Video downloader
		zenstates # Ryzen CPU controller
    vpn-exclude # Run shell with another gateway and IP
	];

	users.defaultUserShell = pkgs.zsh; # Use ZSH shell for all users

	programs = {
		zsh = {
			enable = true;
			# Enable oh my zsh and it's plugins
			ohMyZsh = {
				enable = true;
				plugins = [ "git" "npm" "nvm" "sudo" "systemd" ];
			};
			autosuggestions.enable = true;

			syntaxHighlighting.enable = true;

			# Aliases
			shellAliases = {
				apx = "apx --aur"; # Use arch as the base apx container
				aria2c = "aria2c -j 16 -s 16"; # Download with aria using best settings
				btrfs-compress = "sudo btrfs filesystem defrag -czstd -r -v"; # Compress given path with zstd
				cat = "bat"; # Better cat command
				chmod = "sudo chmod"; # It's a command that I always execute with sudo
				clear-keys = "sudo rm -rf ~/ local/share/keyrings/* ~/ local/share/kwalletd/*"; # Clear system keys
				cp = "rsync -rP"; # Copy command with details
				desktop-files-list = "ls -l /run/current-system/sw/share/applications"; # Show desktop files location
				list-packages = "nix-store --query --requisites /run/current-system | cut -d- -f2- | sort | uniq"; # List installed nix packages
				ls = "lsd"; # Better ls command
				mva = "rsync -rP --remove-source-files"; # Move command with details
				n = "tmux a -t nvchad || tmux new -s nvchad nvim"; # Nvchad
				ping = "gping"; # ping with a graph
				reboot-windows = "sudo efibootmgr --bootnext ${config.boot.windows-entry} && reboot"; # Reboot to windows
				rebuild = "(cd $(head -1 /etc/nixos/.configuration-location) 2> /dev/null || (echo 'Configuration path is invalid. Run rebuild.sh manually to update the path!' && false) && bash rebuild.sh)"; # Rebuild the system configuration
				restart-pipewire = "systemctl --user restart pipewire"; # Restart pipewire
				server = "ssh server@192.168.1.2"; # Connect to local server
				ssh = "TERM=xterm-256color ssh"; # SSH with colors
				steam-link = "killall steam 2> /dev/null ; while ps axg | grep -vw grep | grep -w steam > /dev/null; do sleep 1; done && (nohup steam -pipewire > /dev/null &) 2> /dev/null"; # Kill existing steam process and relaunch steam with the pipewire flag
				update = "(cd $(head -1 /etc/nixos/.configuration-location) 2> /dev/null || (echo 'Configuration path is invalid. Run rebuild.sh manually to update the path!' && false) && sudo nix flake update && bash rebuild.sh) ; (apx --aur upgrade) ; (bash ~/.config/zsh/proton-ge-updater.sh) ; (bash ~/.config/zsh/steam-library-patcher.sh)"; # Update everything
				v = "nvim"; # Neovim
				vpn = "ssh -f server@192.168.1.2 'mullvad status'"; # Show VPN status
				vpn-btop = "ssh -t server@192.168.1.2 'bpytop'"; # Show VPN bpytop
				vpn-off = "ssh -f server@192.168.1.2 'mullvad disconnect && sleep 1 && mullvad status'"; # Disconnect from VPN
				vpn-on = "ssh -f server@192.168.1.2 'mullvad connect && sleep 1 && mullvad status'"; # Connect to VPN
			};

			interactiveShellInit = "source ~/.config/zsh/zsh-theme.zsh\nunsetopt PROMPT_SP"; # Commands to run on zsh shell initialization
		};

		gamemode.enable = true;
	};

	services = {
		openssh.enable = true;
		mullvad-vpn.enable = true;
	};

	# Symlink files and folders to /etc
	environment.etc."rnnoise-plugin/librnnoise_ladspa.so".source = "${pkgs.rnnoise-plugin}/lib/ladspa/librnnoise_ladspa.so";
	environment.etc."proton-ge-nix".source = "${(pkgs.callPackage self-built/proton-ge.nix {})}/";
	environment.etc."apx/config.json".source = "${(pkgs.callPackage self-built/apx.nix {})}/etc/apx/config.json";
}
