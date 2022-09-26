### PACKAGES INSTALLED ON WORK USER ###
{ config, pkgs, ... }:

{
    users.users.${config.work.user.username} = {
        packages = with pkgs; [
            docker
            docker-compose
            nodejs-14_x
            terminator
            watchman
        ];
    };

    virtualisation.docker.enable = true;
}
