{ pkgs, lib, config, ...}:

let
	nvidia-offload = pkgs.writeShellScriptBin "nvidia-offload" ''
		export __NV_PRIME_RENDER_OFFLOAD=1
		export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
		export __GLX_VENDOR_LIBRARY_NAME=nvidia
		export __VK_LAYER_NV_optimus=NVIDIA_only
		exec "$@"
	'';
in
lib.mkIf config.laptop.enable {
	services.auto-cpufreq.enable = true;
	environment.systemPackages = [ pkgs.brightnessctl nvidia-offload ];

	hardware.nvidia.prime = lib.mkIf config.nvidia.enable {
		offload.enable = true;
		intelBusId = "PCI:0:2:0";
		nvidiaBusId = "PCI:1:0:0";
	};
}
