{ config, pkgs, ... }:

{
	imports = [
		# GPU
		./radeon.nix
		# CPU
		./ryzen.nix
	];
}
