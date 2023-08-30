{ lib, stdenv, fetchFromGitHub, kernel, bluez, nixosTests }:

stdenv.mkDerivation (finalAttrs: {
  pname = "xpadneo";
  version = "git";

  src = fetchFromGitHub {
    owner = "atar-axis";
    repo = "xpadneo";
    # rev = "refs/tags/v${finalAttrs.version}";
    rev = "9b3b6968304d75faca00d1cead63f89e8895195f";
    sha256 = "8XRyMXPqtQ413C2Rso2jA78Qv/UXWu2gmRgBHyAl6Rw=";
  };

  setSourceRoot = ''
    export sourceRoot=$(pwd)/source/hid-xpadneo/src
  '';

  nativeBuildInputs = kernel.moduleBuildDependencies;
  buildInputs = [ bluez ];

  makeFlags = kernel.makeFlags ++ [
    "-C"
    "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "M=$(sourceRoot)"
    "VERSION=${finalAttrs.version}"
  ];

  buildFlags = [ "modules" ];
  installFlags = [ "INSTALL_MOD_PATH=${placeholder "out"}" ];
  installTargets = [ "modules_install" ];

  passthru.tests = { xpadneo = nixosTests.xpadneo; };

  meta = with lib; {
    description = "Advanced Linux driver for Xbox One wireless controllers";
    homepage = "https://atar-axis.github.io/xpadneo";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ kira-bruneau ];
    platforms = platforms.linux;
  };
})
