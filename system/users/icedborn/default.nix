{
  pkgs,
  ...
}:

{
  users.users.icedborn.packages = with pkgs; [
    appimage-run
    blanket
    faugus-launcher
    fragments
    gimp3
    harmony-music
    newsflash
    umu-launcher
    warp
  ];
}
