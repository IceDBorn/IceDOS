{ stdenvNoCC, fetchFromGitHub, ... }:

stdenvNoCC.mkDerivation rec {
  name = "firefox-gnome-theme";
  version = "121";

  src = fetchFromGitHub {
    owner = "rafaelmardojai";
    repo = "firefox-gnome-theme";
    rev = "v${version}";
    sha256 = "M+Cw6vh7xCDmIhyVuEPNmaNVUwpmdFQq8zlsXZTKees=";
  };

  preferLocalBuild = true;

  installPhase = ''
    mkdir -p $out
    cp -r ./* $out/
  '';
}
