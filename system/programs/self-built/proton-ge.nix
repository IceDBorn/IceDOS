{ stdenvNoCC, fetchFromGitHub, ... }:

stdenvNoCC.mkDerivation rec {
  name = "proton-ge";
  version = "GE-Proton8-10";

  src = builtins.fetchTarball {
    url = "https://github.com/GloriousEggroll/proton-ge-custom/releases/download/${version}/${version}.tar.gz";
    sha256 = "156g915s33mp1ayawgkk62191bk7m16ncc1n079m9g48knhwy64c";
  };

  preferLocalBuild = true;

  installPhase = ''
    mkdir -p $out/${version}
    cp -r ./ $out/${version}
  '';
}
