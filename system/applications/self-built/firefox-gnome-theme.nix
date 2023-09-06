{ stdenvNoCC, fetchFromGitHub, ... }:

stdenvNoCC.mkDerivation rec {
  name = "firefox-gnome-theme";
  version = "117";

  src = fetchFromGitHub {
    owner = "rafaelmardojai";
    repo = "firefox-gnome-theme";
    rev = "v${version}";
    sha256 = "ulG+9TcjI27RQF/5t7i+ED38gLuK5jbXNJHBxs4QBV0=";
  };

  preferLocalBuild = true;

  installPhase = ''
    mkdir -p $out
    cp -r ./* $out/
  '';
}
