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
  lout = import modules/lout.nix { inherit pkgs; };

  rebuild = import modules/rebuild.nix {
    inherit pkgs config;
    command = "rebuild";
    update = "false";
  };

  toggle-services = import modules/toggle-services.nix { inherit pkgs; };
  trim-generations = import modules/trim-generations.nix { inherit pkgs; };

  update = import modules/rebuild.nix {
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
    ./modules/android-tools.nix
    ./modules/aria2c.nix
    ./modules/bash.nix
    ./modules/brave.nix
    ./modules/btop
    ./modules/celluloid
    ./modules/clamav.nix
    ./modules/codium
    ./modules/container-manager.nix
    ./modules/deckbd-wrapper.nix
    ./modules/fwupd.nix
    ./modules/gamemode.nix
    ./modules/garbage-collect
    ./modules/gdm.nix
    ./modules/git.nix
    ./modules/kernel.nix
    ./modules/kitty.nix
    ./modules/librewolf
    ./modules/libvirtd.nix
    ./modules/mangohud.nix
    ./modules/mullvad.nix
    ./modules/php.nix
    ./modules/pitivi.nix
    ./modules/rtl8821ce.nix
    ./modules/rust.nix
    ./modules/solaar.nix
    ./modules/ssh.nix
    ./modules/steam.nix
    ./modules/store.nix
    ./modules/sunshine.nix
    ./modules/tailscale.nix
    ./modules/tmux
    ./modules/waydroid.nix
    ./modules/yazi.nix
    ./modules/zed
    ./modules/zsh
  ];

  environment.systemPackages =
    (pkgMapper pkgFile.packages) ++ myPackages ++ codingDeps ++ shellScripts;

  # Source: https://github.com/NixOS/nixpkgs/blob/5e4fbfb6b3de1aa2872b76d49fafc942626e2add/nixos/modules/system/activation/top-level.nix#L191
  system.extraSystemBuilderCmds = "ln -s ${inputs.self} $out/source";
}
