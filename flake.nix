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
      url = "github:fossar/nix-phps/5c2a9bf0246b7f38b7ca737f0f1f36d5b45ae15a";
      inputs.nixpkgs.url = "github:NixOS/nixpkgs/b73c2221a46c13557b1b3be9c2070cc42cf01eb3";
    };

    pipewire-screenaudio = {
      url = "github:IceDBorn/pipewire-screenaudio";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    shell-in-netns = {
      url = "github:jim3692/shell-in-netns";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:MarceColl/zen-browser-flake";
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

      zen-browser,
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
          ./system/desktop/steam-session.nix

          hyprland.nixosModules.default
          ./system/desktop/hyprland

          ./system/desktop
          ./system/desktop/gnome

          ./system/applications/users/main

        ];
      };
    };
}
