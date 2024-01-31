{ stdenvNoCC }:

stdenvNoCC.mkDerivation rec {
  name = "proton-ge";
  version = "8-30";

  src = builtins.fetchTarball {
    url =
      "https://github.com/GloriousEggroll/proton-ge-custom/releases/download/GE-Proton${version}/GE-Proton${version}.tar.gz";
    sha256 = "12yjxzbdwpg69fi13sn31sf23y8by15vnfydy9hln5id0dk2ya00";
  };

  preferLocalBuild = true;

  installPhase = ''
    mkdir -p "$out/GE-Proton${version}"
    cp -r ./ "$out/GE-Proton${version}"
  '';
}
