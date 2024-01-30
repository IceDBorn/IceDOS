{ stdenvNoCC }:

stdenvNoCC.mkDerivation rec {
  name = "proton-ge";
  version = "8-29";

  src = builtins.fetchTarball {
    url =
      "https://github.com/GloriousEggroll/proton-ge-custom/releases/download/GE-Proton${version}/GE-Proton${version}.tar.gz";
    sha256 = "1pnfmsj0lkkmchacrri6qy7gdv7przlyqfydzp7sg07lqvf1yycn";
  };

  preferLocalBuild = true;

  installPhase = ''
    mkdir -p "$out/GE-Proton${version}"
    cp -r ./ "$out/GE-Proton${version}"
  '';
}
