{ pkgs, lib, config, ... }:

lib.mkIf config.amd.gpu.enable {
  boot.initrd.kernelModules = [ "amdgpu" ]; # Use the amdgpu drivers upon boot

  services.xserver.videoDrivers = [ "amdgpu" ];

  programs.corectrl = {
    enable = true;
    gpuOverclock = {
      enable = true;
      ppfeaturemask = "0xffffffff"; # Unlock all gpu controls
    };
  };

  # Do not ask for password when launching corectrl
  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
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
    corectrl # GPU overclocking tool
    nvtop-amd # GPU task manager
  ];
}
