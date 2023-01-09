{ stdenvNoCC, fetchFromGitHub, python3, ... }:

stdenvNoCC.mkDerivation rec {
	name = "adwaita-for-steam";
	version = "0.26";

	src = fetchFromGitHub {
		owner = "tkashkin";
		repo = "Adwaita-for-Steam";
		rev = "v0.26";
		sha256 = "3VyMnO/gRnyf4EcSbjUj4EYl1AmpPK5L5MOtxgN3m5w=";
	};

	preferLocalBuild = true;

	nativeBuildInputs = [ python3 ];

	patches = [ ./install.patch ];

	installPhase = ''
		mkdir -p $out
		NIX_OUT="$out" python install.py -w full
	'';
}
