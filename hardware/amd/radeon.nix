{ config, pkgs, ... }:

{
	boot.initrd.kernelModules = [ "amdgpu" ];

	services.xserver.videoDrivers = [ "amdgpu" ];

	programs.corectrl = {
		enable = true;
		gpuOverclock = {
			enable = true;
			ppfeaturemask = "0xffffffff";
		};
	};

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

	environment.systemPackages = [ pkgs.unstable.corectrl ];
}
