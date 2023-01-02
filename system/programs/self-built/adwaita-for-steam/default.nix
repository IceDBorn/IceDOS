{ stdenvNoCC, fetchFromGitHub, python3, ... }:

stdenvNoCC.mkDerivation rec {
	name = "adwaita-for-steam";
	version = "0.23";

	src = fetchFromGitHub {
		owner = "tkashkin";
		repo = "Adwaita-for-Steam";
		rev = "v0.23";
		sha256 = "LH+SyOGbg0oG4MceLF0/mry2KzDGlsUP5aLElB4Ra28=";
	};

	preferLocalBuild = true;

	nativeBuildInputs = [ python3 ];

	patches = [ ./install.patch ];

	installPhase = ''
		mkdir -p $out
		NIX_OUT="$out" python install.py -w full
	'';
}
