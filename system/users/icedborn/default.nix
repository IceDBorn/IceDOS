{
  pkgs,
  ...
}:

let
  launchers = with pkgs; [
    # cemu
    # duckstation
    # heroic
    # pcsx2
    # ppsspp
    # prismlauncher
    # rpcs3
  ];
in
{
  users.users.icedborn.packages =
    with pkgs;
    [
      appimage-run
      blanket
      faugus-launcher
      fragments
      gimp
      harmony-music
      newsflash
      umu-launcher
      warp
    ]
    ++ launchers;
}
