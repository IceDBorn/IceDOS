{ stdenvNoCC, fetchFromGitHub, python3, ... }:

stdenvNoCC.mkDerivation {
	name = "adwaita-for-steam";
	# version = "0.38";
	version = "beta";

	src = fetchFromGitHub {
		owner = "Foldex";
		repo = "Adwaita-for-Steam";
		# rev = "v${version}";
		rev = "fc7d40ff1afba26d66e462aa22616ffa76c637f8";
		sha256 = "ihFPapFIBTOrp0aZGhNpc3z7kknXdgPz1WXQqlPUR0o=";
	};

	preferLocalBuild = true;

	nativeBuildInputs = [ python3 ];

	patches = [ ./install.patch ];

	installPhase = ''
		mkdir -p $out/build
		NIX_OUT="$out" python install.py -we library/hide_whats_new -we login/hover_qr -we windowcontrols/hide-close
	'';
}
