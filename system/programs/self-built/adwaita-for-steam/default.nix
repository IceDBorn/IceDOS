{ stdenvNoCC, fetchFromGitHub, python3, ... }:

stdenvNoCC.mkDerivation {
	name = "adwaita-for-steam";
	version = "0.38";

	src = fetchFromGitHub {
		owner = "tkashkin";
		repo = "Adwaita-for-Steam";
		# rev = "v${version}";
		rev = "78c03447b83fc1f2b9b5194299b21a1f1f5f8f16";
		sha256 = "rTeGUb2jAeUSrcRbmNvkkEOHqYRUrqDia0YWo/ux3uE=";
	};

	preferLocalBuild = true;

	nativeBuildInputs = [ python3 ];

	patches = [ ./install.patch ];

	installPhase = ''
		mkdir -p $out
		NIX_OUT="$out" python install.py
	'';
}
