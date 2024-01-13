{
  inputs = {
    # Update channels
    master.url = "github:NixOS/nixpkgs/master";
    small.url = "github:NixOS/nixpkgs/nixos-unstable-small";
    unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Modules
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "unstable";
    };

    nur.url = "github:nix-community/NUR";
    steam-session.url = "github:Jovian-Experiments/Jovian-NixOS";

    # Apps
    hycov = {
      url = "github:DreamMaoMao/hycov";
      inputs.hyprland.follows = "hyprland";
    };

    hyprland.url = "github:hyprwm/Hyprland";
    phps.url = "github:fossar/nix-phps";
    pipewire-screenaudio.url = "github:IceDBorn/pipewire-screenaudio";
  };

  outputs = { self, master, small, unstable, home-manager, nur, steam-session
    , hycov, hyprland, phps, pipewire-screenaudio }@inputs: {
      nixosConfigurations.${unstable.lib.fileContents "/etc/hostname"} =
        unstable.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            # Read configuration location
            {
              options = with unstable.lib; {
                configurationLocation = mkOption {
                  type = types.str;
                  default =
                    unstable.lib.fileContents "/tmp/.configuration-location";
                };
              };
            }

            # External modules
            nur.nixosModules.nur
            home-manager.nixosModules.home-manager
            hyprland.nixosModules.default
            steam-session.nixosModules.default

            # Internal modules
            ./modules.nix
          ];
        };
    };
}
