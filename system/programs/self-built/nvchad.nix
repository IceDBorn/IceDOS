{ stdenvNoCC, fetchFromGitHub, ... }:

stdenvNoCC.mkDerivation rec {
	name = "nvchad";
	version = "2.0";

	src = fetchFromGitHub {
		owner = "NvChad";
		repo = "NvChad";
		rev = "refs/heads/v${version}";
		sha256 = "LldvBSROu3/pWqHb8OPbrsD3m0JbZFPyCPUk6AQoIKo=";
	};

	preferLocalBuild = true;

	installPhase = ''
		mkdir -p $out
		cp -r ./ $out
	'';
}
