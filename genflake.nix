let
  cfg = (import ./options.nix { lib = import <nixpkgs/lib>; }).options.icedos;

  steam-session = cfg.applications.steam.session.enable.default;
  hyprland = cfg.desktop.hyprland.enable.default;
  switch-emulators = cfg.applications.emulators.switch.default;
in
{
  flake.nix = ''
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

        ${
          if (steam-session) then
            ''
              steam-session = {
                url = "github:Jovian-Experiments/Jovian-NixOS";
                follows = "chaotic/jovian";
              };
            ''
          else
            ""
        }

        # Apps
        ${
          if (hyprland) then
            ''
              hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
            ''
          else
            ""
        }

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

        ${
          if (switch-emulators) then
            ''
              switch-emulators = {
                url = "git+https:///codeberg.org/K900/yuzu-flake";
                inputs.nixpkgs.follows = "nixpkgs";
              };
            ''
          else
            ""
        }
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
          ${(if (steam-session) then ''steam-session,'' else "")}
          ${(if (hyprland) then ''hyprland,'' else "")}
          ${(if (switch-emulators) then ''switch-emulators,'' else "")}
        }@inputs:
        {
          nixosConfigurations.''${nixpkgs.lib.fileContents "/etc/hostname"} = nixpkgs.lib.nixosSystem {
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

              ${
                (
                  if (steam-session) then
                    ''
                      steam-session.nixosModules.default
                      ./system/desktop/steam-session
                    ''
                  else
                    ""
                )
              }

              ${
                (
                  if (hyprland) then
                    ''
                      hyprland.nixosModules.default
                      ./system/desktop/hyprland
                    ''
                  else
                    ""
                )
              }
            ];
          };
        };
    }
  '';
}
