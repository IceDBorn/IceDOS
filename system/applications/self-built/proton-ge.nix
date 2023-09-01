{ stdenvNoCC }:

stdenvNoCC.mkDerivation rec {
  name = "proton-ge";
  version = "GE-Proton8-14";

  src = builtins.fetchTarball {
    url =
      "https://github.com/GloriousEggroll/proton-ge-custom/releases/download/${version}/${version}.tar.gz";
    sha256 = "1kxnnlx993kwhc3cav96hk4csdq72930wf6rf3msl7k6lpfhkbzz";
  };

  preferLocalBuild = true;

  installPhase = ''
    mkdir -p $out/${version}
    cp -r ./ $out/${version}
  '';
}
