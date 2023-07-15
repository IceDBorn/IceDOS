{ stdenvNoCC, fetchFromGitHub, ... }:

stdenvNoCC.mkDerivation {
	name = "firefox-cascade";
	version = "git";

	src = fetchFromGitHub {
		owner = "andreasgrafen";
		repo = "cascade";
		rev = "a89173a67696a8bf43e8e2ac7ed93ba7903d7a70";
		sha256 = "D4ZZPm/li1Eoo1TmDS/lI2MAlgosNGOOk4qODqIaCes=";
	};

	preferLocalBuild = true;

	installPhase = ''
		mkdir -p $out
    sed -i '/#unified-extensions-button { display: none !important; }/d' ./chrome/includes/cascade-config.css
    echo "#webrtcIndicator { display: none }" >> ./chrome/includes/cascade-config.css
		cp -r ./chrome/* $out/
	'';
}
