{
	inputs = {
		hyprland.url = "github:hyprwm/Hyprland/2df0d034bc4a18fafb3524401eeeceaa6b23e753";
		nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
		nur.url = "github:nix-community/NUR";

		home-manager = {
			url = "github:nix-community/home-manager";
			inputs.nixpkgs.follows = "nixpkgs";
		};
	};

	outputs = inputs@{ self, nixpkgs, hyprland, home-manager, nur }: {
		nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
			system = "x86_64-linux";
			specialArgs = {inherit inputs;};
			modules = [
				nur.nixosModules.nur
				home-manager.nixosModules.home-manager
				hyprland.nixosModules.default
				{ programs.hyprland.enable = true; }
				./configuration.nix
			];
		};
	};
}
