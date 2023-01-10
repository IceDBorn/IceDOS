{ pkgs, lib, config, ...}:

{
	services.auto-cpufreq.enable = config.laptop.enable;
	environment.systemPackages = lib.mkIf config.laptop.enable [ pkgs.brightnessctl ];
}
