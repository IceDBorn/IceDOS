{
  inputs = {
    # Update channels
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    master.url = "github:NixOS/nixpkgs/master";
    small.url = "github:NixOS/nixpkgs/nixos-unstable-small";
    stable.url = "github:NixOS/nixpkgs/23.11";

    unstable = {
      follows = "chaotic/nixpkgs";
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };

    # Modules
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "unstable";
    };

    nerivations.url = "github:icedborn/nerivations";
    nur.url = "github:nix-community/NUR";

    steam-session = {
      follows = "chaotic/jovian";
      url = "github:Jovian-Experiments/Jovian-NixOS";
    };

    # Apps
    hyprland.url = "github:hyprwm/Hyprland";
    phps.url = "github:fossar/nix-phps";
    pipewire-screenaudio.url = "github:IceDBorn/pipewire-screenaudio";
    shell-in-netns.url = "github:jim3692/shell-in-netns";
    yuzu.url = "git+https:///codeberg.org/K900/yuzu-flake";
  };

  outputs = { self, chaotic, master, small, stable, unstable, home-manager
    , nerivations, nur, steam-session, hyprland, phps, pipewire-screenaudio
    , shell-in-netns, yuzu }@inputs: {
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
                    unstable.lib.fileContents "/tmp/configuration-location";
                };
              };
            }

            # External modules
            chaotic.nixosModules.default
            home-manager.nixosModules.home-manager
            hyprland.nixosModules.default
            nerivations.nixosModules.default
            nur.nixosModules.nur
            steam-session.nixosModules.default

            # Internal modules
            ./modules.nix
          ];
        };
    };
}
