{ stdenvNoCC, fetchFromGitHub, ... }:

stdenvNoCC.mkDerivation rec {
  name = "firefox-gnome-theme";
  version = "116";

  src = fetchFromGitHub {
    owner = "rafaelmardojai";
    repo = "firefox-gnome-theme";
    rev = "v${version}";
    sha256 = "0IS5na2WRSNWNygHhmZOcXhdrx2aFhCDQY8XVVeHf8Q=";
  };

  preferLocalBuild = true;

  installPhase = ''
    mkdir -p $out
    cp -r ./* $out/
  '';
}
