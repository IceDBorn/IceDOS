{ stdenvNoCC, fetchFromGitHub, ... }:

stdenvNoCC.mkDerivation rec {
  name = "arkenfox-userjs";
  version = "115.0";

  src = fetchFromGitHub {
    owner = "arkenfox";
    repo = "user.js";
    rev = version;
    sha256 = "knJa1zI27NsKGwpps3MMrG9K7HDGCDnoRfm16pNR/yM=";
  };

  preferLocalBuild = true;

  installPhase = ''
    cat ${../configs/firefox/user-overrides.js} >> user.js
    mkdir -p $out
    cp ./user.js $out/user.js
  '';
}
