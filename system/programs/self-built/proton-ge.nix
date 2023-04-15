{ stdenvNoCC, fetchFromGitHub, ... }:

stdenvNoCC.mkDerivation rec {
	name = "proton-ge";
	version = "GE-Proton7-55";

	src = builtins.fetchTarball {
		url = "https://github.com/GloriousEggroll/proton-ge-custom/releases/download/${version}/${version}.tar.gz";
		sha256 = "0szrza88ic0rx6y90y1s655faxfz7lq24315zw0xl107gvszw8p8";
	};

	preferLocalBuild = true;

	installPhase = ''
		mkdir -p $out/${version}
		cp -r ./ $out/${version}
	'';
}
