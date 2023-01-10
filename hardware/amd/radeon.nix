{ pkgs, lib, config, ... }:

{
	boot.initrd.kernelModules = lib.mkIf config.amd.gpu.enable [ "amdgpu" ]; # Use the amdgpu drivers upon boot

	services.xserver.videoDrivers = lib.mkIf config.amd.gpu.enable [ "amdgpu" ];

	programs.corectrl = lib.mkIf config.amd.gpu.enable {
		enable = true;
		gpuOverclock = {
			enable = true;
			ppfeaturemask = "0xffffffff"; # Unlock all gpu controls
		};
	};

	# Do not ask for password when launching corectrl
	security.polkit.extraConfig = lib.mkIf config.amd.gpu.enable ''
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

	environment.systemPackages = lib.mkIf config.amd.gpu.enable [ pkgs.corectrl ]; # GPU overclocking tool
}
