{ config, pkgs, ... }:

{
	boot.initrd.kernelModules = [ "amdgpu" ];

	services.xserver.videoDrivers = [ "amdgpu" ];

	# Let the program choose between radeon and amdvlk drivers
	hardware.opengl = with pkgs; {
		extraPackages = [ amdvlk ];
		extraPackages32 = [ driversi686Linux.amdvlk ];
	};

	programs = {
		xwayland.enable = true;

		corectrl = {
			enable = true;
			gpuOverclock = {
				enable = true;
				ppfeaturemask = "0xffffffff";
			};
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

	environment.systemPackages = [ pkgs.corectrl ];
}
