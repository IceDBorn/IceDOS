{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mapAttrs mkIf;
  cfg = config.icedos;
in
{
  home-manager.users = mapAttrs (user: _: {
    home.packages =
      let
        watcher = cfg.system.users.${user}.desktop.idle.sd-inhibitor.watchers.cpu;
      in
      mkIf (cfg.system.users.${user}.desktop.idle.sd-inhibitor.enable && watcher.enable) [
        (pkgs.writeShellScriptBin "cpu-watcher" ''
          UTILIZATION="$((100-$(vmstat 1 2|tail -1|awk '{print $15}')))"
          CPU_THRESOLD=${toString (watcher.threshold)}

          if (( UTILIZATION > CPU_THRESOLD )) then
              printf true
          else
              printf false
          fi
        '')
      ];
  }) cfg.system.users;
}
