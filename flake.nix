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

      follows = "chaotic/home-manager";

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

    hyprlux = {
      url = "github:amadejkastelic/Hyprlux";
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

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs =
    {
      home-manager,
      nerivations,
      nixpkgs,
      pipewire-screenaudio,
      self,
      shell-in-netns,

      hyprlux,
      chaotic,

      steam-session,

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

          # Symlink configuration state on "/run/current-system/source"
          {
            # Source: https://github.com/NixOS/nixpkgs/blob/5e4fbfb6b3de1aa2872b76d49fafc942626e2add/nixos/modules/system/activation/top-level.nix#L191
            system.extraSystemBuilderCmds = "ln -s ${self} $out/source";
          }

          # Internal modules
          ./modules.nix

          # External modules
          chaotic.nixosModules.default

          home-manager.nixosModules.home-manager
          nerivations.nixosModules.default

          ./system/desktop

          steam-session.nixosModules.default
          ./system/desktop/steam-session.nix

          hyprlux.nixosModules.default
          ./system/desktop/hyprland
          ./system/applications/modules/hyprlux.nix

          ./system/applications/modules/zen-browser

          ./system/users/icedborn.nix

        ];
      };
    };
}
