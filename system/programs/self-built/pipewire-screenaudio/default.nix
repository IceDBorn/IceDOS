{ lib, stdenv, fetchFromGitHub, pipewire, jq, hexdump, gawk, psmisc, ... }:

stdenv.mkDerivation rec {
	pname = "pipewire-screenaudio";
  	version = "0.2.0";

	src = fetchFromGitHub {
		owner = "IceDBorn";
		repo = "pipewire-screenaudio";
		rev = version;
		sha256 = "IfPW0qmIUMIuevMLolYyKpYMBiiBG1OJA7/Wtxp+EzM=";
  	};

  buildInputs = [ pipewire jq hexdump gawk psmisc ];

	installPhase = ''
		mkdir -p $out/lib/out
		install -Dm755 native/connector/pipewire-screen-audio-connector.sh $out/lib/connector/pipewire-screen-audio-connector.sh
		install -Dm755 native/connector/virtmic.sh $out/lib/connector/virtmic.sh

		# Firefox manifest
		sed -i "s|/usr/lib/pipewire-screenaudio|$out/lib|g" native/native-messaging-hosts/firefox.json
		install -Dm644 native/native-messaging-hosts/firefox.json $out/lib/mozilla/native-messaging-hosts/com.icedborn.pipewirescreenaudioconnector.json
	'';
}
