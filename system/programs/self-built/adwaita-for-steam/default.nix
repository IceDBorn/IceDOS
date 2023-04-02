{ stdenvNoCC, fetchFromGitHub, python3, ... }:

stdenvNoCC.mkDerivation rec {
	name = "adwaita-for-steam";
	version = "0.36";

	src = fetchFromGitHub {
		owner = "tkashkin";
		repo = "Adwaita-for-Steam";
		rev = "v${version}";
		sha256 = "1j+jJED9r9t4OAPz86lwZvN25jaAlOUnLEOMPo0biG4=";
	};

	preferLocalBuild = true;

	nativeBuildInputs = [ python3 ];

	patches = [ ./install.patch ];

	installPhase = ''
		mkdir -p $out
		NIX_OUT="$out" python install.py
	'';
}
