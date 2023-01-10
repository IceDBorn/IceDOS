{ pkgs, lib, config, ... }:

{
	boot.kernelModules = lib.mkIf config.amd.cpu.enable [ "msr" ]; # Needed for zenstates

	hardware.cpu.amd.updateMicrocode = config.amd.cpu.enable;

	# Ryzen cpu control
	systemd.services.zenstates = lib.mkIf config.amd.cpu.enable {
		enable = true;
		description = "Ryzen Undervolt";
		after = [ "syslog.target" "systemd-modules-load.service" ];

		unitConfig = {
			ConditionPathExists = "${pkgs.zenstates}/bin/zenstates";
		};

		serviceConfig = {
			User = "root";
			ExecStart = "${pkgs.zenstates}/bin/zenstates ${config.amd.cpu.undervolt}";
		};

		wantedBy = [ "multi-user.target" ];
	};
}
