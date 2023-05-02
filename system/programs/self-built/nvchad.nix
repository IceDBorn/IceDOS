{ stdenvNoCC, fetchFromGitHub, ... }:

stdenvNoCC.mkDerivation rec {
	name = "nvchad";
	version = "2.0";

	src = fetchFromGitHub {
		owner = "NvChad";
		repo = "NvChad";
		rev = "refs/heads/v${version}";
		sha256 = "i71S96cHmLTTpEb5xzf1tH2qBYnOFIxYhOEwWaGpv04=";
	};

	preferLocalBuild = true;

	installPhase = ''
		mkdir -p $out
		cp -r ./ $out
	'';
}
