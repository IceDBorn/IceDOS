{ stdenvNoCC, fetchFromGitHub, ... }:

stdenvNoCC.mkDerivation {
	name = "firefox-cascade";
	version = "git";

	src = fetchFromGitHub {
		owner = "andreasgrafen";
		repo = "cascade";
		rev = "9403343b9fb055767e32b7deb5c9a9c3c078b76e";
		sha256 = "v6BcTyq57VcQ0pCErpnUgluelqlStmA1GnGJWGSFeIU=";
	};

	preferLocalBuild = true;

	installPhase = ''
		mkdir -p $out
    sed -i '/#unified-extensions-button { display: none !important; }/d' ./chrome/includes/cascade-config.css
    echo "#webrtcIndicator { display: none }" >> ./chrome/includes/cascade-config.css
		cp -r ./chrome/* $out/
	'';
}
