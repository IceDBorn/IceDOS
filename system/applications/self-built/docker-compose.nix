{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "docker-compose";
  version = "2.24.2";

  src = fetchFromGitHub {
    owner = "docker";
    repo = "compose";
    rev = "v${version}";
    hash = "";
  };

  postPatch = ''
    # entirely separate package that breaks the build
    rm -rf e2e/
  '';

  vendorHash = "sha256-oeGGRyxz28OPAPueGhRHAvb3LnRfW8mA5fzmjq1G14o=";

  ldflags = [ "-X github.com/docker/compose/v2/internal.Version=${version}" "-s" "-w" ];

  doCheck = false;
  installPhase = ''
    runHook preInstall
    install -D $GOPATH/bin/cmd $out/libexec/docker/cli-plugins/docker-compose

    mkdir -p $out/bin
    ln -s $out/libexec/docker/cli-plugins/docker-compose $out/bin/docker-compose
    runHook postInstall
  '';
}
