{ stdenvNoCC, fetchFromGitHub, python3, config, ... }:

stdenvNoCC.mkDerivation rec {
  name = "adwaita-for-steam";
  version = "1.16";

  src = fetchFromGitHub {
    owner = "tkashkin";
    repo = "Adwaita-for-Steam";
    rev = "v${version}";
    sha256 = "oSd/Qv+T3d/3sdNSV8cLPUmzmqYQiCFEHelY0Ku5ftA=";
  };

  preferLocalBuild = true;

  nativeBuildInputs = [ python3 ];

  patches = [ ./install.patch ];

  installPhase = ''
    mkdir -p $out/build
    NIX_OUT="$out" python install.py ${config.applications.steam.adwaitaForSteam.extras}
  '';
}
