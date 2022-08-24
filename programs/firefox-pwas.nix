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
