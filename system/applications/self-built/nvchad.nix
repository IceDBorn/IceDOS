{ stdenvNoCC, fetchFromGitHub, ... }:

stdenvNoCC.mkDerivation rec {
  name = "nvchad";
  version = "2.0";

  src = fetchFromGitHub {
    owner = "NvChad";
    repo = "NvChad";
    rev = "refs/heads/v${version}";
    sha256 = "PJm2zYIcRSHoEGG5IC1EPRzjkR9oyPZfId251YV/kXE=";
  };

  preferLocalBuild = true;

  installPhase = ''
    mkdir -p $out
    cp -r ./ $out
  '';
}
