{ stdenvNoCC, fetchFromGitHub, ... }:

stdenvNoCC.mkDerivation rec {
  name = "arkenfox-userjs";
  version = "117.0";

  src = fetchFromGitHub {
    owner = "arkenfox";
    repo = "user.js";
    rev = version;
    sha256 = "mvQwK11nhZ9yiP9ONeHrP2by5h1UgFSABWkI25YjlN4=";
  };

  preferLocalBuild = true;

  installPhase = ''
    cat ${../configs/firefox/user-overrides.js} >> user.js
    mkdir -p $out
    cp ./user.js $out/user.js
  '';
}
