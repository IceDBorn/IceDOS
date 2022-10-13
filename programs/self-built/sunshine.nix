{ stdenv, fetchgit, cmake, pkgconfig
, lib
, openssl, boost, libpulseaudio, libopus, ffmpeg, libevdev, libffi
, icu
, xorg
, libdrm, libcap, mesa
, wayland
, avahi
, cudatoolkit
, enableDrm ? true
, enableCuda ? false
, config, pkgs, ...
}:

let sunshine = pkgs.stdenv.mkDerivation rec {
        name = "sunshine-" + version;
        version = "v0.14.1";

        src = pkgs.fetchgit {
            url = "https://github.com/LizardByte/Sunshine.git";
            fetchSubmodules = true;
            rev = "refs/tags/${version}";
            sha256 = "156nqgrwygvwm47acvyv42hgk4mpn06i6mh4qg42rnhzwq0867a8";
        };

        nativeBuildInputs = [ pkgs.pkgconfig pkgs.cmake pkgs.wayland pkgs.libdrm pkgs.libcap pkgs.cudatoolkit ];

        cmakeFlags = ["-DSUNSHINE_ASSETS_DIR=share/assets" "-DSUNSHINE_CONFIG_DIR=share/config"] ++
        # always enable X11
        ["-DSUNSHINE_ENABLE_X11=ON" "-DSUNSHINE_ENABLE_WAYLAND=ON" "-DSUNSHINE_ENABLE_DRM=ON" "-DSUNSHINE_ENABLE_CUDA=ON"];

        postPatch = ''
            sed -i -e 's|/usr/include/libevdev-1.0|${pkgs.libevdev}/include/libevdev-1.0|' ./CMakeLists.txt
            sed -i -e 's/-Wno-format/-Wno-format -Wno-format-security/' ./third-party/cbs/CMakeLists.txt
        '';

        buildInputs = [
            # common
            pkgs.openssl pkgs.libpulseaudio pkgs.libopus pkgs.ffmpeg pkgs.libevdev pkgs.libffi
            pkgs.icu
            (pkgs.boost.override { enableShared = false; }) # boost need static
            # x11
            pkgs.xorg.libXtst pkgs.xorg.libX11 pkgs.xorg.libXrandr pkgs.xorg.libXfixes pkgs.xorg.libxcb
            ];

        postFixup = ''
            patchelf \
            --set-rpath $(patchelf --print-rpath $out/bin/sunshine-*):${pkgs.mesa}/lib:${pkgs.avahi}/lib:/run/opengl-driver/lib \
            $out/bin/sunshine-*
        '';

        meta = with lib; {
            description = "Sunshine is a Gamestream host for Moonlight.";
            longDescription = ''
            Sunshine is a self hosted, low latency, cloud gaming solution with support for AMD,
            Intel, and Nvidia GPUs. It is an open source implementation of NVIDIA's GameStream, as used by the NVIDIA Shield.
            Connect to Sunshine from any Moonlight client, available for nearly any device imaginable.
            '';
            homepage = https://app.lizardbyte.dev;
            changelog = "https://github.com/LizardByte/Sunshine/releases/tag/${version}";
            license = licenses.gpl3;
            platforms = platforms.linux;
        };
};
in 
{
    users.users.${config.main.user.username}.packages = [ sunshine ];

    security.wrappers = {
        sunshine = {
            owner = "root";
            group = "root";
            capabilities = "cap_sys_admin+p";
            source = "${sunshine}/bin/sunshine";
        };
    };
}