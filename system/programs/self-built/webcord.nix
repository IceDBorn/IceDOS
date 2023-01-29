{ lib, stdenv, buildNpmPackage, fetchFromGitHub, copyDesktopItems, python3, rustc, pipewire, libpulseaudio, electron, makeDesktopItem }:

buildNpmPackage rec {
  name = "webcord";
  version = "4.0.0";

  src = fetchFromGitHub {
    owner = "IceDBorn";
    repo = "WebCord";
    rev = "f962496bd65f5d5a01e04c9759a4f997f8ea82b3";
    sha256 = "xgUkmEoKjRO/WIyxooOq8t3AjMT5xHZ1Kl94+pCvBd8=";
  };

  npmDepsHash = "sha256-+2kJxvKt0g7ZkONqSv/3V3tKxtZbRl/yI6KPiHXGcG8=";

  nativeBuildInputs = [
    copyDesktopItems
    python3
  ];

  libPath = lib.makeLibraryPath [
    pipewire
    libpulseaudio
  ];

  # npm install will error when electron tries to download its binary
  # we don't need it anyways since we wrap the program with our nixpkgs electron
  ELECTRON_SKIP_BINARY_DOWNLOAD = "1";

  # remove husky commit hooks, errors and aren't needed for packaging
  postPatch = ''
    rm -rf .husky
  '';

  # override installPhase so we can copy the only folders that matter
  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/node_modules/webcord
	mkdir -p $out/lib/node_modules/webcord/node_modules/node-pipewire
    cp -r app node_modules sources package.json $out/lib/node_modules/webcord/
	cp -r prebundled-node-modules/node-pipewire/* $out/lib/node_modules/webcord/node_modules/node-pipewire/

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
