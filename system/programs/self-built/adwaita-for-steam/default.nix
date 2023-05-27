{ stdenvNoCC, fetchFromGitHub, python3, ... }:

stdenvNoCC.mkDerivation {
	name = "adwaita-for-steam";
	# version = "0.38";
	version = "beta";

	src = fetchFromGitHub {
		owner = "Foldex";
		repo = "Adwaita-for-Steam";
		# rev = "v${version}";
		rev = "55d169fc70d9ca0f29a071d0054436262eb9f431";
		sha256 = "2IJxZG9EPBq/6MgExxssuKwUwmbRyTPpn2HEwefifcQ=";
	};

	preferLocalBuild = true;

	nativeBuildInputs = [ python3 ];

	patches = [ ./install.patch ];

	installPhase = ''
		mkdir -p $out/build
		NIX_OUT="$out" python install.py -we library/hide_whats_new -we login/hover_qr -we windowcontrols/hide-close
	'';
}
