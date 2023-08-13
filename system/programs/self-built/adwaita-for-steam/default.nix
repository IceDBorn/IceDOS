{ stdenvNoCC, fetchFromGitHub, python3, ... }:

stdenvNoCC.mkDerivation rec {
  name = "adwaita-for-steam";
  version = "1.11";

  src = fetchFromGitHub {
    owner = "tkashkin";
    repo = "Adwaita-for-Steam";
    rev = "v${version}";
    sha256 = "0V0+knSgaiWO6CrOEowM2VIDM+Gi0GBxgzAio4rlvSk=";
  };

  preferLocalBuild = true;

  nativeBuildInputs = [ python3 ];

  patches = [ ./install.patch ];

  installPhase = ''
    mkdir -p $out/build
    NIX_OUT="$out" python install.py -e library/hide_whats_new -e library/sidebar_hover -e login/hover_qr -e windowcontrols/hide-close
  '';
}
