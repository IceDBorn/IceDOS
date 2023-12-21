{ stdenvNoCC, fetchFromGitHub, ... }:

stdenvNoCC.mkDerivation rec {
  name = "nvchad";
  version = "2.0";

  src = fetchFromGitHub {
    owner = "NvChad";
    repo = "NvChad";
    rev = "refs/heads/v${version}";
    sha256 = "J4SGwo/XkKFXvq+Va1EEBm8YOQwIPPGWH3JqCGpFnxY=";
  };

  preferLocalBuild = true;

  installPhase = ''
    mkdir -p $out
    cp -r ./ $out
  '';
}
