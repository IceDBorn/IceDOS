{ stdenvNoCC, fetchFromGitHub, python3, ... }:

stdenvNoCC.mkDerivation rec {
	name = "adwaita-for-steam";
	version = "0.29";

	src = fetchFromGitHub {
		owner = "tkashkin";
		repo = "Adwaita-for-Steam";
		rev = "v0.29";
		sha256 = "5zo53QW+HJbKYqMHfhWDkhJ3DBESIqiFZx8J3E9yhpQ=";
	};

	preferLocalBuild = true;

	nativeBuildInputs = [ python3 ];

	patches = [ ./install.patch ];

	installPhase = ''
		mkdir -p $out
		NIX_OUT="$out" python install.py -w full
	'';
}
