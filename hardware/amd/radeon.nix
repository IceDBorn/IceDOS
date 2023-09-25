{ pkgs, lib, config, ... }:

lib.mkIf config.hardware.gpu.amd.enable {
  boot.initrd.kernelModules = [ "amdgpu" ]; # Use the amdgpu drivers upon boot

  programs.corectrl = {
    enable = true;
    gpuOverclock = {
      enable = true;
      ppfeaturemask = "0xffffffff"; # Unlock all gpu controls
    };
  };

  # Do not ask for password when launching corectrl
  security.polkit.extraConfig = ''
    polkit.addRule(function (action, subject) {
      if ((action.id == "org.corectrl.helper.init" ||
          action.id == "org.corectrl.helperkiller.init") &&
          subject.local == true &&
          subject.active == true &&
          subject.isInGroup("users")) {
        return polkit.Result.YES;
      }
    });
  '';

  environment.systemPackages = with pkgs; [
    nvtop-amd # GPU task manager
    lact
  ];

  # We are creating the lact daemon service manually because the provided one hangs
  systemd.services.lactd = {
    enable = true;
    description = "Radeon GPU monitor";
    after = [ "syslog.target" "systemd-modules-load.service" ];

    unitConfig = { ConditionPathExists = "${pkgs.lact}/bin/lact"; };

    serviceConfig = {
      User = "root";
      ExecStart = "${pkgs.lact}/bin/lact daemon";
    };

    wantedBy = [ "multi-user.target" ];
  };
}
