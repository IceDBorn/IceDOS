{ stdenvNoCC, fetchFromGitHub, python3, ... }:

stdenvNoCC.mkDerivation rec {
	name = "adwaita-for-steam";
	version = "0.28";

	src = fetchFromGitHub {
		owner = "tkashkin";
		repo = "Adwaita-for-Steam";
		rev = "v0.28";
		sha256 = "TShO64tVg0nWkERIUp4Wmp1rM//xPWtHHLYm80vTfcA=";
	};

	preferLocalBuild = true;

	nativeBuildInputs = [ python3 ];

	patches = [ ./install.patch ];

	installPhase = ''
		mkdir -p $out
		NIX_OUT="$out" python install.py -w full
	'';
}
