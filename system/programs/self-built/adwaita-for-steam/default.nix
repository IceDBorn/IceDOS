{ stdenvNoCC, fetchFromGitHub, python3, ... }:

stdenvNoCC.mkDerivation {
	name = "adwaita-for-steam";
	version = "0.38";

	src = fetchFromGitHub {
		owner = "Foldex";
		repo = "Adwaita-for-Steam";
		# rev = "v${version}";
		rev = "951831fdfe125aeead9833a331955fbc124a07f1";
		sha256 = "78mHgMXrWQB3e+z6D8+wXPD5aN2oB2ZaX0RW8ikY0aQ=";
	};

	preferLocalBuild = true;

	nativeBuildInputs = [ python3 ];

	patches = [ ./install.patch ];

	installPhase = ''
		mkdir -p $out/build
		NIX_OUT="$out" python install.py -we library/hide_whats_new -we login/hover_qr -we windowcontrols/hide-close
	'';
}
