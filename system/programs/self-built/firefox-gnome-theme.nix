{ stdenvNoCC, fetchFromGitHub, ... }:

stdenvNoCC.mkDerivation rec {
	name = "firefox-gnome-theme";
	version = "115";

	src = fetchFromGitHub {
		owner = "rafaelmardojai";
		repo = "firefox-gnome-theme";
		rev = "v${version}";
		sha256 = "YuvNdDX1UAAJpoVMMUnmC20aRuIB5OuzZfaDHUEKFBQ=";
	};

	preferLocalBuild = true;

	installPhase = ''
		mkdir -p $out
		cp -r ./* $out/
	'';
}
