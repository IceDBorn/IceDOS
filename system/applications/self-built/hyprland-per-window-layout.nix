{ fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "hyprland-per-window-layout";
  version = "2.2";

  src = fetchFromGitHub {
    owner = "coffebar";
    repo = "hyprland-per-window-layout";
    rev = version;
    sha256 = "rYyWVGNktX82lo3b14e/AFANwc1pD/18Xi6VdbPPjlw=";
  };

  cargoSha256 = "DDr3ZdkBWggd9Vv5UAX49mHs8SMR944L75wRICZ0mzY=";
}
