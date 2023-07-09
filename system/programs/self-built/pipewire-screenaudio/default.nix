{ lib, stdenv, fetchFromGitHub, pipewire, cmake, git, tl-expected, jq, hexdump, gawk, ... }:

stdenv.mkDerivation rec {
	pname = "pipewire-screenaudio";
  	version = "0.0.1";

	src = fetchFromGitHub {
		owner = "IceDBorn";
		repo = "pipewire-screenaudio";
		rev = version;
		sha256 = "jXvMSL3iZ+ql7ZYja6cJF13kDzmZtQm/LUQI0dFISoo=";
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
			cd ./pipewire-screenaudio/rohrkabel/
			git apply $rootPath/rohrkabel-cmake.patch
		)

		bash build.sh
	'';

	installPhase = ''
		mkdir -p $out/lib/out
		install -Dm755 connector/pipewire-screen-audio-connector.sh $out/lib/connector/pipewire-screen-audio-connector.sh
		install -Dm755 out/pipewire-screenaudio $out/lib/out/pipewire-screenaudio

		# Firefox manifest
		sed -i "s|/usr/lib/pipewire-screenaudio|$out/lib|g" native-messaging-hosts/firefox.json
		install -Dm644 native-messaging-hosts/firefox.json $out/lib/mozilla/native-messaging-hosts/com.icedborn.pipewirescreenaudioconnector.json
	'';
}
