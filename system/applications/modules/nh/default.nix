{
  config,
  pkgs,
  ...
}:

let
  cfg = config.icedos.system.generations.garbageCollect;
  days = "${builtins.toString (cfg.days)}d";
  generations = builtins.toString (cfg.generations);
in
{
  environment.systemPackages = [
    (pkgs.writeShellScriptBin "nix-gc" "nh clean all -k ${generations} -K ${days}")
  ];

  programs.nh = {
    enable = true;

    clean = {
      enable = cfg.automatic;
      extraArgs = "-k ${builtins.toString (cfg.generations)} -K ${days}";
      dates = cfg.interval;
    };
  };
}
