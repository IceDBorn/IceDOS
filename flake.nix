{
  inputs = {
    # Update channels

    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-unstable";

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

    # Apps

    hyprlux = {
      url = "github:amadejkastelic/Hyprlux";
      inputs.nixpkgs.follows = "nixpkgs";
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

      phps,

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

          home-manager.nixosModules.home-manager
          nerivations.nixosModules.default

          ./system/desktop

          hyprlux.nixosModules.default
          ./system/desktop/hyprland
          ./system/applications/modules/hyprlux.nix

          ./system/applications/modules/zen-browser

          ./system/users/dtek.nix

        ];
      };
    };
}
