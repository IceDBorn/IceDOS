{ stdenvNoCC, fetchFromGitHub, ... }:

stdenvNoCC.mkDerivation rec {
	name = "proton-ge";
	version = "GE-Proton8-4";

	src = builtins.fetchTarball {
		url = "https://github.com/GloriousEggroll/proton-ge-custom/releases/download/${version}/${version}.tar.gz";
		sha256 = "05q6wzp0r5bbi3z8ycm18xxksq2d84737y26xfwvgcxpf2mgdmai";
	};

	preferLocalBuild = true;

	installPhase = ''
		mkdir -p $out/${version}
		cp -r ./ $out/${version}
	'';
}
