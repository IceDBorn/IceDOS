{ config, pkgs, ... }:

{
	imports = [
		# Startup files for main user
		./main.nix

		# Startup files for work user
		./work.nix
	];
}
