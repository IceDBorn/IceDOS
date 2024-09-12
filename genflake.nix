let
  lib = import <nixpkgs/lib>;
  inherit (lib) attrNames concatImapStrings filter;

  cfg = (import ./options.nix { inherit lib; }).config.icedos;
  users = filter (user: cfg.system.users.${user}.enable == true) (attrNames cfg.system.users);

  steam-session = cfg.applications.steam.session.enable;
  hyprland = cfg.desktop.hyprland.enable;
  switch-emulators = cfg.applications.emulators.switch;
  server = cfg.hardware.devices.server.enable;
  zen-browser = cfg.applications.zen-browser.enable;
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

              hyprland-plugins = {
                url = "github:hyprwm/hyprland-plugins";
                inputs.hyprland.follows = "hyprland";
              };

              hyprlux = {
                url = "github:amadejkastelic/Hyprlux";
                inputs.nixpkgs.follows = "hyprland/nixpkgs";
              };
            ''
          else
            ""
        }

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

        ${
          if (zen-browser) then
            ''
              zen-browser = {
                url = "github:MarceColl/zen-browser-flake";
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
          ${if (steam-session) then ''steam-session,'' else ""}
          ${if (hyprland) then ''hyprland,hyprland-plugins,hyprlux,'' else ""}
          ${if (switch-emulators) then ''switch-emulators,'' else ""}
          ${if (zen-browser) then ''zen-browser,'' else ""}
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
                if (!server && steam-session) then
                  ''
                    steam-session.nixosModules.default
                    ./system/desktop/steam-session.nix
                  ''
                else
                  ""
              }

              ${
                if (!server && hyprland) then
                  ''
                    hyprland.nixosModules.default
                    hyprlux.nixosModules.default
                    ./system/desktop/hyprland
                    ./system/applications/modules/hyprlux.nix
                  ''
                else
                  ""
              }

              ${
                if (!server) then
                  ''
                    ./system/desktop
                    ./system/desktop/gnome
                  ''
                else
                  ""
              }

              ${concatImapStrings (i: user: "./system/applications/users/${user}\n") users}
            ];
          };
        };
    }
  '';
}
