{ lib, stdenv, buildNpmPackage, fetchFromGitHub, copyDesktopItems, python3, rustc, pipewire, libpulseaudio, electron, makeDesktopItem }:

buildNpmPackage rec {
	name = "webcord";
	version = "4.1.1";
	nodePipewireVersion = "1.0.14";

	src = fetchFromGitHub {
		owner = "kakxem";
		repo = "WebCord";
		rev = "e5c2ded3ee53b6397736a262bbec5d253375b745";
		sha256 = "oFQ7fVJysmVUlhRMPxg/0w7srnXXu7gZ/kxlJZ2OW3g=";
	};

	npmDepsHash = "sha256-fg8BBVcNYeXipMX33Eh7wmDP27bp3NTM0FO+ld0jWF4=";

	nativeBuildInputs = [
		copyDesktopItems
		python3
	];

	libPath = lib.makeLibraryPath [
		pipewire
		libpulseaudio
	];

	patches = [ ./node-pipewire.patch ];

	# npm install will error when electron tries to download its binary
	# we don't need it anyways since we wrap the program with our nixpkgs electron
	ELECTRON_SKIP_BINARY_DOWNLOAD = "1";

	# remove husky commit hooks, errors and aren't needed for packaging
	postPatch = ''
		rm -rf .husky
	'';

	nodePipewire = builtins.fetchTarball {
		url = "https://github.com/kakxem/node-pipewire/releases/download/${nodePipewireVersion}/node-v108-linux-x64.tar.gz";
		sha256 = "046fhaqz06sdnvrmvq02i2k1klv90sgyz24iz3as0hmr6v90ldm1";
	};

	# override installPhase so we can copy the only folders that matter
	installPhase = ''
		runHook preInstall

		mkdir -p $out/lib/node_modules/webcord
		mkdir -p $out/lib/node_modules/webcord/node_modules/node-pipewire
		cp -r app node_modules sources package.json $out/lib/node_modules/webcord/
		cp -r ${nodePipewire}/* $out/lib/node_modules/webcord/node_modules/node-pipewire/

		install -Dm644 sources/assets/icons/app.png $out/share/icons/hicolor/256x256/apps/webcord.png

		makeWrapper '${electron}/bin/electron' $out/bin/webcord \
		--prefix LD_LIBRARY_PATH : ${libPath}:$out/opt/webcord \
		--add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform=wayland}}" \
		--add-flags $out/lib/node_modules/webcord/

		runHook postInstall
	'';

	desktopItems = [
		(makeDesktopItem {
		name = "webcord";
		exec = "webcord";
		icon = "webcord";
		desktopName = "WebCord";
		comment = meta.description;
		categories = [ "Network" "InstantMessaging" ];
		})
	];

	meta = with lib; {
		description = "A Discord and Fosscord electron-based client implemented without Discord API";
		homepage = "https://github.com/SpacingBat3/WebCord";
		downloadPage = "https://github.com/SpacingBat3/WebCord/releases";
		changelog = "https://github.com/SpacingBat3/WebCord/releases/tag/v${version}";
		license = licenses.mit;
		maintainers = with maintainers; [ huantian ];
		platforms = platforms.linux;
	};
}
