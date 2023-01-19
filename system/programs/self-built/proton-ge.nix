{ stdenvNoCC, fetchFromGitHub, ... }:

stdenvNoCC.mkDerivation rec {
	name = "proton-ge";
	version = "GE-Proton7-45";

	src = builtins.fetchTarball {
		url = "https://github.com/GloriousEggroll/proton-ge-custom/releases/download/${version}/${version}.tar.gz";
		sha256 = "1yzqz36dgc8clil19s910b3x65rl2f72dlvli4nrz4l1snvx5v5n";
	};

	preferLocalBuild = true;

	installPhase = ''
		mkdir -p $out/${version}
		cp -r ./ $out/${version}
	'';
}
