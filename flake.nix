{
  inputs = {
    hyprland.url = "github:hyprwm/Hyprland";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nur.url = "github:nix-community/NUR";
    pipewire-screenaudio.url = "github:IceDBorn/pipewire-screenaudio";
    steam-session.url = "github:Jovian-Experiments/Jovian-NixOS";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    phps.url = "github:fossar/nix-phps";
  };

  outputs = { self, nixpkgs, hyprland, home-manager, nur, pipewire-screenaudio
    , steam-session, phps }@inputs: {
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          nur.nixosModules.nur
          home-manager.nixosModules.home-manager
          hyprland.nixosModules.default
          steam-session.nixosModules.default
          ./configuration.nix
        ];
      };
    };
}
