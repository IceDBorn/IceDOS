{
  config,
  lib,
  ...
}:

let
  inherit (lib) mkIf;
  cfg = config.icedos;
in
mkIf (cfg.desktop.gdm.enable && !cfg.applications.steam.session.autoStart.enable) {
  services = {
    displayManager.gdm = {
      enable = true;
      autoSuspend = cfg.desktop.gdm.autoSuspend;
    };

    xserver = {
      enable = true;
      xkb.layout = "us,gr";
    };
  };

  # Workaround for autologin
  systemd.services = {
    "getty@tty1".enable = false;
    "autovt@tty1".enable = false;
  };
}
