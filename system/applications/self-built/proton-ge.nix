{ stdenvNoCC }:

stdenvNoCC.mkDerivation rec {
  name = "proton-ge";
  version = "8-23";

  src = builtins.fetchTarball {
    url =
      "https://github.com/GloriousEggroll/proton-ge-custom/releases/download/GE-Proton${version}/GE-Proton${version}.tar.gz";
    sha256 = "0w20gk56xg2x0h065d0f5hhsifdm4kwpvw0lc91k8a7zhwly4yfx";
  };

  preferLocalBuild = true;

  installPhase = ''
    mkdir -p "$out/GE-Proton${version}"
    cp -r ./ "$out/GE-Proton${version}"
  '';
}
