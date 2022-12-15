{ pkgs, ...}:

{
	services.auto-cpufreq.enable = true;
	environment.systemPackages = with pkgs; [ brightnessctl ];
}
