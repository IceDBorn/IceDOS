{ stdenvNoCC, fetchFromGitHub, ... }:

stdenvNoCC.mkDerivation rec {
	name = "nvchad";
	version = "2.0";

	src = fetchFromGitHub {
		owner = "NvChad";
		repo = "NvChad";
		rev = "refs/heads/v${version}";
		sha256 = "7c2DmZe7olC7575syftoiF0DfmIVox9rPDgy0Qj/uV8=";
	};

	preferLocalBuild = true;

	installPhase = ''
		mkdir -p $out
		cp -r ./ $out
	'';
}
