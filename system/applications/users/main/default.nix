# PACKAGES INSTALLED ON MAIN USER
{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:

let
  inherit (lib)
    foldl'
    lists
    mkIf
    optional
    splitString
    ;

  pkgMapper =
    pkgList: lists.map (pkgName: foldl' (acc: cur: acc.${cur}) pkgs (splitString "." pkgName)) pkgList;

  cfg = config.icedos;
  username = cfg.system.users.main.username;

  install-proton-ge = import ../../modules/wine-build-updater.nix {
    inherit pkgs;
    name = "proton-ge";
    buildPath = "${pkgs.proton-ge-custom}/bin";
    installPath = "/home/${username}/.local/share/Steam/compatibilitytools.d";
    message = "proton ge";
    type = "Proton";
  };

  install-wine-ge = import ../../modules/wine-build-updater.nix {
    inherit pkgs;
    name = "wine-ge";
    buildPath = "${pkgs.wine-ge}/bin";
    installPath = "/home/${username}/.local/share/bottles/runners";
    message = "wine ge";
    type = "Wine";
  };

  # Update the system configuration
  update = import ../../modules/rebuild.nix {
    inherit pkgs config;
    command = "update";
    update = "true";
  };

  emulators =
    with pkgs;
    [ ]
    ++ optional (cfg.applications.emulators.switch) inputs.switch-emulators.packages.${pkgs.system}.suyu
    ++ optional (cfg.applications.emulators.wiiu) cemu;

  shellScripts = [
    update
    install-wine-ge
    install-proton-ge
  ];
in
mkIf (cfg.system.users.main.enable) {
  users.users.${username}.packages =
    (pkgMapper (lib.importJSON ./packages.json)) ++ emulators ++ shellScripts;

  # Wayland microcompositor
  programs = {
    gamescope = mkIf (!cfg.applications.steam.session.enable) {
      enable = true;
      capSysNice = true;
    };

    steam = {
      enable = true;

      # Needed for steam controller to work on wayland compositors when the steam client is open
      extest.enable = cfg.hardware.devices.steamdeck;
    };
  };

  services = {
    input-remapper = {
      enable = true;
      enableUdevRules = true;
    };
  };
}
