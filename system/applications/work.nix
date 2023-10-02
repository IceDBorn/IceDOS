# PACKAGES INSTALLED ON WORK USER
{ config, pkgs, lib, ... }:

let
  configuration-location = builtins.readFile ../../.configuration-location;

  update = pkgs.writeShellScriptBin "update" ''
    stashLock=$(git stash push -m "flake.lock@$(date +%A-%d-%B-%T)" flake.lock > /dev/null)
      # Navigate to configuration directory
      cd ${configuration-location} 2> /dev/null || (echo 'Configuration path is invalid. Run build.sh manually to update the path!' && exit 2)

      # Stash the flake lock file
      if [ $(git stash list | wc -l) -eq 0 ]; then
        $stashLock
      else
        [ -n "$(git diff stash flake.lock)" ] && $stashLock
      fi

      nix flake update && bash build.sh
      apx --aur upgrade
      bash ~/.config/zsh/update-codium-extensions.sh
  '';
in lib.mkIf config.system.user.work.enable {
  users.users.${config.system.user.work.username}.packages = with pkgs;
    [
      update # Update the system configuration
    ];
}
