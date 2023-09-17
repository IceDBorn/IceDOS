{ stdenvNoCC }:

stdenvNoCC.mkDerivation rec {
  name = "proton-ge";
  version = "8-15";

  src = builtins.fetchTarball {
    url =
      ''https://github.com/GloriousEggroll/proton-ge-custom/releases/download/"GE-Proton"${version}"/"GE-Proton${version}".tar.gz'';
    sha256 = "02ny0n8spf3835cxc62hbscrh2np2w7yl387fkgbbwv5hj0zqc2b";
  };

  preferLocalBuild = true;

  installPhase = ''
    mkdir -p "$out/GE-Proton${version}"
    cp -r ./ "$out/GE-Proton${version}"
  '';
}
