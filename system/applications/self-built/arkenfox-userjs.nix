{ stdenvNoCC, fetchFromGitHub, ... }:

stdenvNoCC.mkDerivation rec {
  name = "arkenfox-userjs";
  version = "115.1";

  src = fetchFromGitHub {
    owner = "arkenfox";
    repo = "user.js";
    rev = version;
    sha256 = "M523JiwiZR0mwjyjNaojSERFt77Dp75cg0Ifd6wTOdU=";
  };

  preferLocalBuild = true;

  installPhase = ''
    cat ${../configs/firefox/user-overrides.js} >> user.js
    mkdir -p $out
    cp ./user.js $out/user.js
  '';
}
