{ stdenvNoCC, fetchFromGitHub, ... }:

stdenvNoCC.mkDerivation {
  name = "firefox-cascade";
  version = "git";

  src = fetchFromGitHub {
    owner = "andreasgrafen";
    repo = "cascade";
    rev = "e5d9d9b81eb9ea16e27e72087ca6a39cf17594bd";
    sha256 = "xOihSEXn73tNSv1GhJJzBHXg+8azLvR3H/Iu+vM0y3w=";
  };

  preferLocalBuild = true;

  installPhase = ''
    mkdir -p $out
    sed -i '/#unified-extensions-button { display: none !important; }/d' ./chrome/includes/cascade-config.css
    echo "#webrtcIndicator { display: none }" >> ./chrome/includes/cascade-config.css
    cp -r ./chrome/* $out/
  '';
}
