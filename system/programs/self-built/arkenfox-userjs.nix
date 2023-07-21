{ stdenvNoCC, fetchFromGitHub, ... }:

stdenvNoCC.mkDerivation rec {
  name = "arkenfox-userjs";
  version = "112.0";

  src = fetchFromGitHub {
    owner = "arkenfox";
    repo = "user.js";
    rev = version;
    sha256 = "k4PF8FWN6U+//UmZX4UxzBWbfAgEwQznLVsaFV/fVKo=";
  };

  preferLocalBuild = true;

  installPhase = ''
    cat ${../../configs/firefox/user-overrides.js} >> user.js
    mkdir -p $out
    cp ./user.js $out/user.js
  '';
}
