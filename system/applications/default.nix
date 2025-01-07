{
  pkgs,
  config,
  inputs,
  lib,
  ...
}:

let
  inherit (lib) foldl' lists splitString;

  pkgMapper =
    pkgList: lists.map (pkgName: foldl' (acc: cur: acc.${cur}) pkgs (splitString "." pkgName)) pkgList;

  pkgFile = lib.importTOML ./packages.toml;
  myPackages = (pkgMapper pkgFile.myPackages);
  codingDeps = (pkgMapper pkgFile.codingDeps);
  lout = import modules/lout { inherit pkgs; };

  rebuild = import modules/rebuild {
    inherit pkgs config;
    command = "rebuild";
    update = "false";
  };

  toggle-services = import modules/toggle-services { inherit pkgs; };
  trim-generations = import modules/trim-generations { inherit pkgs; };

  update = import modules/rebuild {
    inherit pkgs config;
    command = "update";
    update = "true";
  };

  shellScripts = [
    inputs.shell-in-netns.packages.${pkgs.system}.default
    lout
    rebuild
    toggle-services
    trim-generations
    update
  ];
in
{
  imports = [
    ./modules/android-tools
    ./modules/aria2c
    ./modules/bash
    ./modules/brave
    ./modules/btop
    ./modules/celluloid
    ./modules/clamav
    ./modules/codium
    ./modules/container-manager
    ./modules/deckbd-wrapper
    ./modules/fwupd
    ./modules/gamemode
    ./modules/gdm
    ./modules/git
    ./modules/kernel
    ./modules/kitty
    ./modules/librewolf
    ./modules/libvirtd
    ./modules/mangohud
    ./modules/mullvad
    ./modules/nh
    ./modules/php
    ./modules/pitivi
    ./modules/rtl8821ce
    ./modules/rust
    ./modules/solaar
    ./modules/ssh
    ./modules/steam
    ./modules/store
    ./modules/sunshine
    ./modules/tailscale
    ./modules/tmux
    ./modules/waydroid
    ./modules/yazi
    ./modules/zed
    ./modules/zsh
  ];

  environment.systemPackages =
    (pkgMapper pkgFile.packages) ++ myPackages ++ codingDeps ++ shellScripts;

  # Allow proprietary packages
  nixpkgs.config.allowUnfree = true;
}
