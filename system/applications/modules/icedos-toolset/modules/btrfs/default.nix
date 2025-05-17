{
  pkgs,
  ...
}:

{
  icedos.internals.toolset.commands = [
    (
      let
        command = "btrfs-zstd";
      in
      {
        bin = "${pkgs.writeShellScript command ''
          if [[ "$1" == "" ]]; then
            echo "error: specify path as an argument"
            exit 1
          fi

          sudo "${pkgs.btrfs-progs}/bin/btrfs" filesystem defrag -czstd -r -v "$@"
        ''}";
        command = command;
        help = "compress btrfs path using zstd";
      }
    )
  ];
}
