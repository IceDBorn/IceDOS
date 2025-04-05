{
  pkgs,
  ...
}:

{
  icedos.internals.toolset.commands = [
    (
      let
        command = "download";
      in
      {
        bin = "${pkgs.writeShellScript command ''
          if [[ "$1" == "" ]]; then
            echo "error: specify url as an argument"
            echo "usage: icedos download [OPTIONS] [URI | MAGNET | TORRENT_FILE | METALINK_FILE]..."
            echo "help: icedos download -h"
            exit 1
          fi

          "${pkgs.aria}/bin/aria2c" -j 16 -s 16 "$@"
        ''}";
        command = command;
        help = "download provided url using aria2c utizing 16 connections";
      }
    )
  ];
}
