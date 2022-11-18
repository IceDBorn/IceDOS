{ config, pkgs, ... }:

{
	imports = [
		# Packages installed for all users
		./global.nix
		# Packages installed for main user
		./main.nix
		# Packages installed for work user
		./work.nix
		# Home manager specific stuff
		./home.nix
	];

	# Nix Package Manager settings
	nix = {
		settings = {
			# Nix automatically detects files in the store that have identical contents, and replaces them with hard links (makes store 3 times slower)
			auto-optimise-store = true;
			# Enable flakes
			experimental-features = [ "nix-command" "flakes" ];
		};

		# Automatic garbage collection
		gc = {
			automatic = true;
			dates = "weekly";
			options = "--delete-older-than 7d";
		};
	};

	# Nix Packages settings
	nixpkgs.config = {
		# Allow proprietary packages
		allowUnfree = true;

		# Install NUR
		packageOverrides = pkgs: {
			# Add NUR, use with "nur.repo.package"
			nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
				inherit pkgs;
			};
		};
	};
}
