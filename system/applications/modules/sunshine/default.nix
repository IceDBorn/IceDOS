{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.icedos.applications.sunshine;
  package = pkgs.sunshine;
in
lib.mkIf (cfg) {
  environment.systemPackages = [ package ];

  security.wrappers.sunshine = {
    owner = "root";
    group = "root";
    source = "${package}/bin/sunshine";
    capabilities = "cap_sys_admin+p";
  };

  services.udev.packages = [
    (pkgs.writeTextFile {
      name = "sunshine_udev";
      text = ''
        KERNEL=="uinput", SUBSYSTEM=="misc", OPTIONS+="static_node=uinput", TAG+="uaccess"
      '';
      destination = "/etc/udev/rules.d/85-sunshine.rules";
    })
  ];
}
