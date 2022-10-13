### PROTON GE DOWNLOADER ###
{ config, pkgs, ... }:

let
    # Convert protonup-ng python package to a nix package
    protonup-ng = pkgs.python3Packages.buildPythonPackage rec {
        pname = "protonup-ng";
        version = "0.2.1";
        doCheck = false;


        propagatedBuildInputs = with pkgs.python3Packages; [
            requests
            wheel
            setuptools
            configparser
        ];
        src = (pkgs.python3Packages.fetchPypi {
            inherit pname version;
            sha256 = "rys9Noa3+w4phttfcI1OGEDfHMy8s80bm8kM8TzssQA=";
        });

        meta = with pkgs.lib; {
            homepage = "https://github.com/cloudishBenne/protonup-ng";
            description = "ProtonUp-ng: CLI program and API to automate the installation and update of GloriousEggroll's Proton-GE";
            license = licenses.gpl3;
            maintainers = with maintainers; [];
        };
    };
in
{
    users.users.${config.main.user.username}.packages = [ protonup-ng ];
}
