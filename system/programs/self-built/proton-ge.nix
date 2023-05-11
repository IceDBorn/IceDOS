{ stdenvNoCC, fetchFromGitHub, ... }:

stdenvNoCC.mkDerivation rec {
	name = "proton-ge";
	version = "GE-Proton8-3";

	src = builtins.fetchTarball {
		url = "https://github.com/GloriousEggroll/proton-ge-custom/releases/download/${version}/${version}.tar.gz";
		sha256 = "";
	};

	preferLocalBuild = true;

	installPhase = ''
		mkdir -p $out/${version}
		cp -r ./ $out/${version}
	'';
}
