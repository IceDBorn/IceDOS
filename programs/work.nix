### PACKAGES INSTALLED ON WORK USER ###
{ config, pkgs, ... }:

{
	users.users.${config.work.user.username} = {
		packages = with pkgs; [
			docker-compose
			nodejs-14_x
			nodePackages.firebase-tools
			slack
			terminator
			watchman
		];
	};
}
