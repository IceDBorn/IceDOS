{ buildGoModule, fetchFromGitHub, distrobox, ... }:

buildGoModule rec {
	name = "apx";
	version = "1.8.1";

	src = fetchFromGitHub {
		owner = "Vanilla-OS";
		repo = "apx";
		rev = version;
		sha256 = "5yIRK0VRm1YXff08vSxVmQ9jgVLjedFDR6XcoA3Jb18=";
	};

	vendorSha256 = null;

	installPhase = ''
		install -D $GOPATH/bin/apx $out/bin/apx

		mkdir -p $out/share/man/man1
		mkdir -p $out/share/man/es/man1
		mkdir -p $out/etc/apx

		cp "man/man1/apx.1" "$out/share/man/man1/apx.1"
		cp "man/es/man1/apx.1" "$out/share/man/es/man1/apx.1"

		cat <<EOF > $out/etc/apx/config.json
		{
			"containername": "apx_managed",
			"image": "docker.io/library/archlinux",
			"pkgmanager": "aur",
			"distroboxpath": "${distrobox}/bin/distrobox"
		}
	'';
}
