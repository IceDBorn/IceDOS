let
  inherit (lib) attrNames concatImapStrings filter;
  cfg = (import ./options.nix { inherit lib; }).config.icedos;
  aagl = cfg.applications.aagl;
  channels = filter (channel: cfg.system.channels.${channel} == true) (attrNames cfg.system.channels);
  gnome = cfg.desktop.gnome.enable;
  hyprland = cfg.desktop.hyprland.enable;
  lib = import <nixpkgs/lib>;
  php = cfg.applications.php;
  server = cfg.hardware.devices.server.enable;
  steam-session = cfg.applications.steam.session.enable;
  suyu = cfg.applications.suyu;
  users = attrNames cfg.system.users;
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

        ${
          concatImapStrings (i: channel: ''${channel}.url = github:NixOS/nixpkgs/${channel};''\n'') channels
        }

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
          if (aagl) then
            ''
              aagl = {
                url = "github:ezKEa/aagl-gtk-on-nix";
                inputs.nixpkgs.follows = "nixpkgs";
              };
            ''
          else
            ""
        }

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

        ${
          if (php) then
            ''
              phps = {
                url = "github:fossar/nix-phps/5c2a9bf0246b7f38b7ca737f0f1f36d5b45ae15a";
                inputs.nixpkgs.url = "github:NixOS/nixpkgs/b73c2221a46c13557b1b3be9c2070cc42cf01eb3";
              };
            ''
          else
            ""
        }

        pipewire-screenaudio = {
          url = "github:IceDBorn/pipewire-screenaudio";
          inputs.nixpkgs.follows = "nixpkgs";
        };

        shell-in-netns = {
          url = "github:jim3692/shell-in-netns";
          inputs.nixpkgs.follows = "nixpkgs";
        };

        ${
          if (suyu) then
            ''
              suyu = {
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
                url = "github:0xc000022070/zen-browser-flake";
                inputs.nixpkgs.follows = "nixpkgs";
              };
            ''
          else
            ""
        }
      };

      outputs =
        {
          chaotic,
          home-manager,
          nerivations,
          nixpkgs,
          pipewire-screenaudio,
          self,
          shell-in-netns,
          ${if (aagl) then ''aagl,'' else ""}
          ${if (hyprland) then ''hyprland,hyprland-plugins,hyprlux,'' else ""}
          ${if (php) then ''phps,'' else ""}
          ${if (steam-session) then ''steam-session,'' else ""}
          ${if (suyu) then ''suyu,'' else ""}
          ${if (zen-browser) then ''zen-browser,'' else ""}
          ${concatImapStrings (i: channel: ''${channel},'') channels}
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
                concatImapStrings (
                  i: channel:
                  ''({config, ...}: { nixpkgs.config.packageOverrides.${channel} = import ${channel} { config = config.nixpkgs.config; }; })''
                ) channels
              }

              ${
                if (!server) then
                  ''
                    ./system/desktop
                  ''
                else
                  ""
              }

              ${
                if (steam-session) then
                  ''
                    steam-session.nixosModules.default
                    ./system/desktop/steam-session.nix
                  ''
                else
                  ""
              }

              ${
                if (aagl) then
                  ''
                    aagl.nixosModules.default
                    {
                      nix.settings = aagl.nixConfig; # Set up Cachix
                      programs.anime-game-launcher.enable = true; # Adds launcher and /etc/hosts rules
                    }
                  ''
                else
                  ""
              }

              ${
                if (hyprland) then
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
                if (gnome) then
                  ''
                    ./system/desktop/gnome
                  ''
                else
                  ""
              }

              ${if (zen-browser) then ''./system/applications/modules/zen-browser'' else ""}

              ${concatImapStrings (i: user: "./system/users/${user}.nix\n") users}
            ];
          };
        };
    }
  '';
}
