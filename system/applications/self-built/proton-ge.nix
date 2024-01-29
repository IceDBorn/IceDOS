{ stdenvNoCC }:

stdenvNoCC.mkDerivation rec {
  name = "proton-ge";
  version = "8-28";

  src = builtins.fetchTarball {
    url =
      "https://github.com/GloriousEggroll/proton-ge-custom/releases/download/GE-Proton${version}/GE-Proton${version}.tar.gz";
    sha256 = "1a6l1pdd16mjzf3pz0rdh7rmlag517rq18d5y0chr29qlhkqnd51";
  };

  preferLocalBuild = true;

  installPhase = ''
    mkdir -p "$out/GE-Proton${version}"
    cp -r ./ "$out/GE-Proton${version}"
  '';
}
