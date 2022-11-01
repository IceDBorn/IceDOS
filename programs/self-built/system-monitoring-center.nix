{ buildPythonApplication, gobject-introspection, girara, wrapGAppsHook, pygobject3, fetchPypi, lib }:

buildPythonApplication rec {
    pname = "system-monitoring-center";
    version = "1.28.0";

    src = (fetchPypi {
        inherit pname version;
        sha256 = "eLoXmhi39RRsGoS5NdpDZRd1Pk2AUT+nhMJB7VijpgA=";
    });

    nativeBuildInputs = [
        gobject-introspection
        girara
        wrapGAppsHook
    ];

    propagatedBuildInputs = [
        pygobject3
        girara
    ];

    doCheck = false;

    meta = with lib; {
        homepage = "https://github.com/hakandundar34coding/system-monitoring-center";
        description = "Provides information about CPU/RAM/Disk/Network/GPU performance, sensors, processes, users, services and system";
        license = licenses.gpl3;
        maintainers = with maintainers; [];
    };
}
