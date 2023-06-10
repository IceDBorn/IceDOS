{ stdenvNoCC, fetchFromGitHub, python3, ... }:

stdenvNoCC.mkDerivation {
	name = "adwaita-for-steam";
	# version = "0.38";
	version = "beta";

	src = fetchFromGitHub {
		owner = "Foldex";
		repo = "Adwaita-for-Steam";
		# rev = "v${version}";
		rev = "a5bb56ab0d221d0bc99df92dd3bc7b853268ba54";
		sha256 = "3ruMMkria1lWBHr+14l5fmzAinEyhX7VuOOEa6I9UB0=";
	};

	preferLocalBuild = true;

	nativeBuildInputs = [ python3 ];

	patches = [ ./install.patch ];

	installPhase = ''
		mkdir -p $out/build
		NIX_OUT="$out" python install.py -we library/hide_whats_new -we login/hover_qr
	'';
}
