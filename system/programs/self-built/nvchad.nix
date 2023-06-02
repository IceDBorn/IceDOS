{ stdenvNoCC, fetchFromGitHub, ... }:

stdenvNoCC.mkDerivation rec {
	name = "nvchad";
	version = "2.0";

	src = fetchFromGitHub {
		owner = "NvChad";
		repo = "NvChad";
		rev = "refs/heads/v${version}";
		sha256 = "VGQqwUKFwWXj/BZ4vRFvQmhovaWoF+7bX3J4/GDNCXc=";
	};

	preferLocalBuild = true;

	installPhase = ''
		mkdir -p $out
		cp -r ./ $out
	'';
}
