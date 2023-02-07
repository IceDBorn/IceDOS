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
			# Hyprland cachix
			substituters = ["https://hyprland.cachix.org"];
			trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
		};

		# Automatic garbage collection
		gc = {
			automatic = true;
			dates = "weekly";
		};
	};

	nixpkgs.config = {
		allowUnfree = true; # Allow proprietary packages
	};
}
