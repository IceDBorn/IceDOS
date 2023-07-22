{ stdenvNoCC, fetchFromGitHub, ... }:

stdenvNoCC.mkDerivation rec {
  name = "proton-ge";
  version = "GE-Proton8-8";

  src = builtins.fetchTarball {
    url = "https://github.com/GloriousEggroll/proton-ge-custom/releases/download/${version}/${version}.tar.gz";
    sha256 = "0n1w2r99arpj71p4fwd4pivbchzkkv80c6l7703gkg6kzs217psm";
  };

  preferLocalBuild = true;

  installPhase = ''
    mkdir -p $out/${version}
    cp -r ./ $out/${version}
  '';
}
