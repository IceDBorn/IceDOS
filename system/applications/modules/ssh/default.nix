{
  config,
  lib,
  ...
}:

let
  inherit (lib) mkIf;
  cfg = config.icedos.applications;
in
mkIf (cfg.ssh) {
  services.openssh.enable = true;
  programs.zsh.shellAliases.ssh = "TERM=xterm-256color ssh";
}
