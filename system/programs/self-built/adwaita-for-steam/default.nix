{ stdenvNoCC, fetchFromGitHub, python3, ... }:

stdenvNoCC.mkDerivation {
	name = "adwaita-for-steam";
	# version = "0.38";
	version = "beta";

	src = fetchFromGitHub {
		owner = "Foldex";
		repo = "Adwaita-for-Steam";
		# rev = "v${version}";
		rev = "19c43290d945278d0025150ba628e6b00439690c";
		sha256 = "u1w20T9OTa9iEh9YZfzR+hGTCe3W77KRNu6XdEPMfmQ=";
	};

	preferLocalBuild = true;

	nativeBuildInputs = [ python3 ];

	patches = [ ./install.patch ];

	installPhase = ''
		mkdir -p $out/build
		NIX_OUT="$out" python install.py -we library/hide_whats_new -we login/hover_qr -we windowcontrols/hide-close
	'';
}
