{ stdenvNoCC }:

stdenvNoCC.mkDerivation rec {
  name = "proton-ge";
  version = "8-27";

  src = builtins.fetchTarball {
    url =
      "https://github.com/GloriousEggroll/proton-ge-custom/releases/download/GE-Proton${version}/GE-Proton${version}.tar.gz";
    sha256 = "00nl7xncffq786kvpvqz8nbv2xiq8w0v4zvm2g6xdsxk1m69ps31";
  };

  preferLocalBuild = true;

  installPhase = ''
    mkdir -p "$out/GE-Proton${version}"
    cp -r ./ "$out/GE-Proton${version}"
  '';
}
