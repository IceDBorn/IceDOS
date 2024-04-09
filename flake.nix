{
  inputs = {
    # Update channels
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";

    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
      follows = "chaotic/nixpkgs";
    };

    # Modules
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nerivations.url = "github:icedborn/nerivations";

    steam-session = {
      url = "github:Jovian-Experiments/Jovian-NixOS";
      follows = "chaotic/jovian";
    };

    # Apps
    hyprland.url = "github:hyprwm/Hyprland";
    phps.url = "github:fossar/nix-phps";
    pipewire-screenaudio.url = "github:IceDBorn/pipewire-screenaudio";
    shell-in-netns.url = "github:jim3692/shell-in-netns";
    yuzu.url = "git+https:///codeberg.org/K900/yuzu-flake";
  };

  outputs =
    {
      self,
      chaotic,
      nixpkgs,
      home-manager,
      nerivations,
      steam-session,
      hyprland,
      phps,
      pipewire-screenaudio,
      shell-in-netns,
      yuzu,
    }@inputs:
    {
      nixosConfigurations.${nixpkgs.lib.fileContents "/etc/hostname"} = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        specialArgs = {
          inherit inputs;
        };

        modules = [
          # Read configuration location
          (
            { lib, ... }:
            let
              inherit (lib) mkOption types fileContents;
            in
            {
              options = {
                configurationLocation = mkOption {
                  type = types.str;
                  default = fileContents "/tmp/configuration-location";
                };
              };
            }
          )

          # Internal modules
          ./modules.nix

          # External modules
          chaotic.nixosModules.default
          home-manager.nixosModules.home-manager
          hyprland.nixosModules.default
          nerivations.nixosModules.default
          steam-session.nixosModules.default
        ];
      };
    };
}
