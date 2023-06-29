{ stdenvNoCC, fetchFromGitHub, python3, ... }:

stdenvNoCC.mkDerivation rec {
	name = "adwaita-for-steam";
	version = "1.3";

	src = fetchFromGitHub {
		owner = "tkashkin";
		repo = "Adwaita-for-Steam";
		rev = "v${version}";
		sha256 = "nRIblZxM7dUxbztcO/xON6GqsZ8RuiyqbKdlPvgXJyA=";
	};

	preferLocalBuild = true;

	nativeBuildInputs = [ python3 ];

	patches = [ ./install.patch ];

	installPhase = ''
		mkdir -p $out/build
		NIX_OUT="$out" python install.py -we library/hide_whats_new -we login/hover_qr
	'';
}
