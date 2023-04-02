{ lib, stdenv, fetchFromGitHub, pipewire, cmake, git, tl-expected, jq, hexdump, gawk, ... }:

stdenv.mkDerivation rec {
	pname = "screenaudio-mic";
  	version = "1.0";

	src = fetchFromGitHub {
		owner = "IceDBorn";
		repo = "screenaudio-mic";
		rev = "3b39b128c0a0acffaaf8b9e6f3ee7f184cc33994";
		sha256 = "HxB2pC86BkHD10fQnK+PPQCdm79lLM+0I2Uj+Hv0WF0=";
		fetchSubmodules = true;
  	};

	patches = [ ./create-rohrkabel-cmake.patch ];

	NIX_CFLAGS_COMPILE = [
		"-I${pipewire.dev}/include/pipewire-0.3"
		"-I${pipewire.dev}/include/spa-0.2"
		"-Wno-pedantic" # Fails without flag
	];

	dontUseCmakeConfigure = true;

	nativeBuildInputs = [ cmake git ];

	buildInputs = [ pipewire tl-expected jq hexdump gawk ];

	libPath = lib.makeLibraryPath [ pipewire ];

	buildPhase = ''
		rootPath=`pwd`
		cd native

		(
			cd ./screenaudio-mic/rohrkabel/
			git apply $rootPath/rohrkabel-cmake.patch
		)

		bash build.sh
	'';

	installPhase = ''
		mkdir -p $out/lib/out
		install -Dm755 screenAudioMicConnector $out/lib/screenAudioMicConnector
		install -Dm755 out/screenaudio-mic $out/lib/out/screenaudio-mic

		# Manifest
		sed -i "s|/usr/lib/screenaudio-mic|$out/lib|g" native-messaging-hosts/screenAudioMicConnector.json
		install -Dm644 native-messaging-hosts/screenAudioMicConnector.json $out/lib/mozilla/native-messaging-hosts/screenAudioMicConnector.json
	'';
}
