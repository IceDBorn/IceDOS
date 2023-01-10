{ buildGoModule, fetchFromGitHub, distrobox, ... }:

buildGoModule rec {
	name = "apx";
	version = "1.4.0";

	src = fetchFromGitHub {
		owner = "Vanilla-OS";
		repo = "apx";
		rev = "44b5c84600788c28e38671238967c282f597e2c0";
		sha256 = "Cl079rAErxRyJjgVZ6gb+mVj3STJMV2lgyk5d6LZEVA=";
	};

	vendorSha256 = "c2hjnDvqjv0lVblnS/T60EzqBqOyE1hIWzwuLVqYRZU=";

	installPhase = ''
		install -D $GOPATH/bin/apx $out/bin/apx

		mkdir -p $out/share/man/man1
		mkdir -p $out/share/man/es/man1
		mkdir -p $out/etc/apx

		cp "man/apx.1" "$out/share/man/man1/apx.1"
		cp "man/es/apx.1" "$out/share/man/es/man1/apx.1"

		cat <<EOF > $out/etc/apx/config.json
		{
			"containername": "apx_managed",
			"image": "docker.io/library/archlinux",
			"pkgmanager": "aur",
			"distroboxpath": "${distrobox}/bin/distrobox"
		}
	'';
}
