{ stdenvNoCC, fetchFromGitHub, ... }:

stdenvNoCC.mkDerivation rec {
	name = "tpm";
	version = "3.1.0";

	src = fetchFromGitHub {
		owner = "tmux-plugins";
		repo = "tpm";
		rev = "v${version}";
		sha256 = "CeI9Wq6tHqV68woE11lIY4cLoNY8XWyXyMHTDmFKJKI=";
	};

	preferLocalBuild = true;

	installPhase = ''
		mkdir -p $out
		cp -r ./ $out
	'';
}
