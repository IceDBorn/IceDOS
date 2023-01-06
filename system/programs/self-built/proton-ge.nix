{ stdenvNoCC, fetchFromGitHub, ... }:

stdenvNoCC.mkDerivation rec {
	name = "proton-ge";
	version = "GE-Proton7-43";

	src = builtins.fetchTarball {
		url = "https://github.com/GloriousEggroll/proton-ge-custom/releases/download/GE-Proton7-43/GE-Proton7-43.tar.gz";
		sha256 = "1qw87ychhx8z5wvzw8w1j0h554mxs9w14glbbn2ywwyhp643h2hb";
	};

	preferLocalBuild = true;

	installPhase = ''
		mkdir -p $out/proton-ge
		cp -r ./ $out/proton-ge
	'';
}
