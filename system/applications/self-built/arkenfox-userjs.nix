{ stdenvNoCC, fetchFromGitHub, ... }:

stdenvNoCC.mkDerivation rec {
  name = "arkenfox-userjs";
  version = "119.0";

  src = fetchFromGitHub {
    owner = "arkenfox";
    repo = "user.js";
    rev = version;
    sha256 = "MAerYaRbaQBqS8WJ3eaq6uxVqQg8diymPbLCU72nDjM=";
  };

  preferLocalBuild = true;

  installPhase = ''
    cat ${../configs/firefox/user-overrides.js} >> user.js
    mkdir -p $out
    cp ./user.js $out/user.js
  '';
}
