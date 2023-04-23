{ stdenvNoCC, fetchFromGitHub, ... }:

stdenvNoCC.mkDerivation rec {
	name = "nvchad";
	version = "2.0";

	src = fetchFromGitHub {
		owner = "NvChad";
		repo = "NvChad";
		rev = "refs/heads/v${version}";
		sha256 = "CxigNtm5QKa62wRTpJS80hHG4Ytyj3LBy2nc+Gy3E2k=";
	};

	preferLocalBuild = true;

	installPhase = ''
		mkdir -p $out
		cp -r ./ $out
	'';
}
