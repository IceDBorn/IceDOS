{ stdenvNoCC, fetchFromGitHub, python3, config, ... }:

stdenvNoCC.mkDerivation rec {
  name = "adwaita-for-steam";
  version = "1.13";

  src = fetchFromGitHub {
    owner = "tkashkin";
    repo = "Adwaita-for-Steam";
    rev = "v${version}";
    sha256 = "CfAV+oOy3WGK8U3GDUzEM/qO8rIZmKVCBd79bawieps=";
  };

  preferLocalBuild = true;

  nativeBuildInputs = [ python3 ];

  patches = [ ./install.patch ];

  installPhase = ''
    mkdir -p $out/build
    NIX_OUT="$out" python install.py ${config.applications.steam.adwaita-for-steam.extras}
  '';
}
