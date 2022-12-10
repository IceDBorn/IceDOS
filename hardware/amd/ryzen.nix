{ pkgs, ... }:

let
	zenstates-options = "-p 0 -v 30 -f A8"; # Pstate 0, 1.25 voltage, 4200 clock speed
in
{
	boot.kernelModules = [ "msr" ]; # Needed for zenstates

	hardware.cpu.amd.updateMicrocode = true;

	# Ryzen cpu control
	systemd.services.zenstates = {
		enable = true;
		description = "Ryzen Undervolt";
		after = [ "syslog.target" "systemd-modules-load.service" ];

		unitConfig = {
			ConditionPathExists = "${pkgs.zenstates}/bin/zenstates";
		};

		serviceConfig = {
			User = "root";
			ExecStart = "${pkgs.zenstates}/bin/zenstates ${zenstates-options}";
		};

		wantedBy = [ "multi-user.target" ];
	};
}
