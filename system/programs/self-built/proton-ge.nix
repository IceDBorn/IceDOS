{ stdenvNoCC, fetchFromGitHub, ... }:

stdenvNoCC.mkDerivation rec {
  name = "proton-ge";
  version = "GE-Proton8-7";

  src = builtins.fetchTarball {
    url = "https://github.com/GloriousEggroll/proton-ge-custom/releases/download/${version}/${version}.tar.gz";
    sha256 = "1x9z12k0ly413h42vs78wzc97f263clqv5b67wkw7xrzmzzmjc22";
  };

  preferLocalBuild = true;

  installPhase = ''
    mkdir -p $out/${version}
    cp -r ./ $out/${version}
  '';
}
