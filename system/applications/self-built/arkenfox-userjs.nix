{ stdenvNoCC, fetchFromGitHub, ... }:

stdenvNoCC.mkDerivation rec {
  name = "arkenfox-userjs";
  version = "122.0";

  src = fetchFromGitHub {
    owner = "arkenfox";
    repo = "user.js";
    rev = version;
    hash = "sha256-624Giuo1TfeXQGzcGK9ETW86esNFhFZ5a46DCjT6K5I=";
  };

  preferLocalBuild = true;

  installPhase = ''
    cat ${../configs/firefox/user-overrides.js} >> user.js
    mkdir -p $out
    cp ./user.js $out/user.js
  '';
}
