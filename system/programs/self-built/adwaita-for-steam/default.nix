{ stdenvNoCC, fetchFromGitHub, python3, ... }:

stdenvNoCC.mkDerivation rec {
	name = "adwaita-for-steam";
	version = "1.0";

	src = fetchFromGitHub {
		owner = "tkashkin";
		repo = "Adwaita-for-Steam";
		rev = "v${version}";
		sha256 = "y7hbQWFyUdIlvB7mwkhX2Y0/OvXD56kRhD3aS9D+nIU=";
	};

	preferLocalBuild = true;

	nativeBuildInputs = [ python3 ];

	patches = [ ./install.patch ];

	installPhase = ''
		mkdir -p $out/build
		NIX_OUT="$out" python install.py -we library/hide_whats_new -we login/hover_qr -we windowcontrols/hide-close
	'';
}
