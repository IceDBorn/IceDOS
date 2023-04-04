{ stdenvNoCC, fetchFromGitHub, ... }:

stdenvNoCC.mkDerivation rec {
	name = "proton-ge";
	version = "GE-Proton7-54";

	src = builtins.fetchTarball {
		url = "https://github.com/GloriousEggroll/proton-ge-custom/releases/download/${version}/${version}.tar.gz";
		sha256 = "1iy14s1d48wxnnmw45jh5w2yadkrvwip8k91xljwg066aprb00vi";
	};

	preferLocalBuild = true;

	installPhase = ''
		mkdir -p $out/${version}
		cp -r ./ $out/${version}
	'';
}
