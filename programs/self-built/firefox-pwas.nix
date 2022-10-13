### FIREFOX PWAS ###
{ config, pkgs, rustPlatform, lib, ... }:

let
    firefox-pwas = pkgs.rustPlatform.buildRustPackage rec {
    pname = "PWAsForFirefox";
    version = "2.0.2";

    src = builtins.fetchTarball "https://github.com/filips123/PWAsForFirefox/archive/refs/tags/v2.0.2.tar.gz";
    sourceRoot = "source/native";

    nativeBuildInputs = [ pkgs.pkg-config ];
    buildInputs = [ pkgs.openssl ];

    cargoHash = "sha256-xsPwuOxg3AR+wvXwTBSakImDPH4VKFG2R3UcScUI0Eo=";

    # patchPhase = ''
    #     sed -i "s/version = \"0.0.0\"/version = \"${version}\"/g" Cargo.toml
    #     sed -i "s/DISTRIBUTION_VERSION = '0.0.0'/DISTRIBUTION_VERSION = '${version}'/g" userchrome/profile/chrome/pwa/chrome.jsm
    # '';

    FFPWA_EXECUTABLES = "{pkgs.firefox-pwas}/bin/firefoxpwa";
    FFPWA_SYSDATA = "{pkgs.firefox-pwas}/native/userchrome";

    meta = with lib; {
        description = "A tool to install, manage and use Progressive Web Apps (PWAs) in Mozilla Firefox.";
        homepage = "https://github.com/filips123/PWAsForFirefox";
        license = licenses.mpl20;
        maintainers = [ maintainers.tailhook ];
    };
};
in
{
    environment.systemPackages = [ firefox-pwas ];
}
