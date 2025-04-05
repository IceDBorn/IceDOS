{
  config,
  pkgs,
  ...
}:

let
  cfg = config.icedos.system.generations.garbageCollect;
  command = "gc";
  days = "${toString (cfg.days)}d";
  generations = toString (cfg.generations);
in
{
  icedos.internals.toolset.commands = [
    {
      bin = "${pkgs.writeShellScript command ''"${pkgs.nh}/bin/nh" clean all -k "${generations}" -K "${days}"''}";
      command = command;
      help = "clean nix plus home manager, store and profiles";
    }
  ];

  programs.nh = {
    enable = true;

    clean = {
      enable = cfg.automatic;
      extraArgs = "-k ${toString (cfg.generations)} -K ${days}";
      dates = cfg.interval;
    };
  };
}
