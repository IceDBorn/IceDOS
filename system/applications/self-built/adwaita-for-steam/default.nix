{ stdenvNoCC, fetchFromGitHub, python3, config, ... }:

stdenvNoCC.mkDerivation rec {
  name = "adwaita-for-steam";
  version = "1.14";

  src = fetchFromGitHub {
    owner = "tkashkin";
    repo = "Adwaita-for-Steam";
    rev = "v${version}";
    sha256 = "g6q9E//EeODjwRi2BkQ3ys+CARTcDyrAMYvtZ/YsNQ8=";
  };

  preferLocalBuild = true;

  nativeBuildInputs = [ python3 ];

  patches = [ ./install.patch ];

  installPhase = ''
    mkdir -p $out/build
    NIX_OUT="$out" python install.py ${config.applications.steam.adwaitaForSteam.extras}
  '';
}
