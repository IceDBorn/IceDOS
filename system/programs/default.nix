{
	imports = [
		# Packages installed for all users
		./global.nix
		# Packages installed for main user
		./main.nix
		# Packages installed for work user
		./work.nix
		# Home manager specific stuff
		./home-main.nix
		./home-work.nix
	];

	nix = {
		settings = {
			auto-optimise-store = true; # Use hard links to save space (slows down package manager)
			experimental-features = [ "nix-command" "flakes" ]; # Enable flakes
		};

		# Automatic garbage collection
		gc = {
			automatic = false;
			dates = "weekly";
		};
	};

	nixpkgs.config = {
		allowUnfree = true; # Allow proprietary packages
	};
}
