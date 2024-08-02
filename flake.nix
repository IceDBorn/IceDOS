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

    nerivations = {
      url = "github:icedborn/nerivations";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    steam-session = {
      url = "github:Jovian-Experiments/Jovian-NixOS";
      follows = "chaotic/jovian";
    };

    # Apps
    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";

    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };

    phps = {
      url = "github:fossar/nix-phps";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    pipewire-screenaudio = {
      url = "github:IceDBorn/pipewire-screenaudio";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    shell-in-netns = {
      url = "github:jim3692/shell-in-netns";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs =
    {
      self,
      chaotic,
      nixpkgs,
      home-manager,
      nerivations,
      phps,
      pipewire-screenaudio,
      shell-in-netns,
      steam-session,
      hyprland,
      hyprland-plugins,

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
              options.icedos.configurationLocation = mkOption {
                type = types.str;
                default = fileContents "/tmp/configuration-location";
              };
            }
          )

          # Internal modules
          ./modules.nix

          # External modules
          chaotic.nixosModules.default
          home-manager.nixosModules.home-manager
          nerivations.nixosModules.default

          steam-session.nixosModules.default
          ./system/desktop/steam-session

          hyprland.nixosModules.default
          ./system/desktop/hyprland

          ./system/applications/users/main

        ];
      };
    };
}
