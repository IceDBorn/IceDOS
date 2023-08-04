{ stdenvNoCC, fetchFromGitHub, ... }:

stdenvNoCC.mkDerivation rec {
  name = "proton-ge";
  version = "GE-Proton8-11";

  src = builtins.fetchTarball {
    url = "https://github.com/GloriousEggroll/proton-ge-custom/releases/download/${version}/${version}.tar.gz";
    sha256 = "0y6kn6dj96pb3y5dhq3lg7g775v9zbs9wx7hrc8xi9pz9vk0mi5r";
  };

  preferLocalBuild = true;

  installPhase = ''
    mkdir -p $out/${version}
    cp -r ./ $out/${version}
  '';
}
