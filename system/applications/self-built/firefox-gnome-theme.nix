{ stdenvNoCC, fetchFromGitHub, ... }:

stdenvNoCC.mkDerivation rec {
  name = "firefox-gnome-theme";
  version = "118";

  src = fetchFromGitHub {
    owner = "rafaelmardojai";
    repo = "firefox-gnome-theme";
    rev = "v${version}";
    sha256 = "jmYHoZYx2/dSvDH/khg7vi2qaKKuXK1g8pnvcRyLw/4=";
  };

  preferLocalBuild = true;

  installPhase = ''
    mkdir -p $out
    cp -r ./* $out/
  '';
}
