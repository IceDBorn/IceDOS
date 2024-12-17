let
  inherit (lib) attrNames concatImapStrings filter;
  cfg = (import ./options.nix { inherit lib; }).config.icedos;
  aagl = cfg.applications.aagl;
  channels = filter (channel: cfg.system.channels.${channel} == true) (attrNames cfg.system.channels);
  falkor = cfg.applications.falkor;
  gnome = cfg.desktop.gnome.enable;
  hyprland = cfg.desktop.hyprland.enable;

  kernel =
    cfg.system.kernel == "cachyos"
    || cfg.system.kernel == "cachyos-server"
    || cfg.system.kernel == "valve";

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
        ${
          if (kernel || steam-session) then
            ''
              chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
            ''
          else
            ""
        }

        nixpkgs = {
          url = "github:NixOS/nixpkgs/nixos-unstable";

          ${
            if (kernel || steam-session) then
              ''
                follows = "chaotic/nixpkgs";
              ''
            else
              ""
          }
        };

        ${concatImapStrings (
          i: channel: ''${channel}.url = github:NixOS/nixpkgs/${channel};''\n''
        ) channels}

        # Modules
        home-manager = {
          url = "github:nix-community/home-manager";

          ${
            if (kernel || steam-session) then
              ''
                follows = "chaotic/home-manager";
              ''
            else
              ''
                inputs.nixpkgs.follows = "nixpkgs";
              ''
          }
        };

        nerivations = {
          url = "github:icedborn/nerivations";
          inputs.nixpkgs.follows = "nixpkgs";
        };

        ${
          if (cfg.system.kernel == "valve" || steam-session) then
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
          if (falkor) then
            ''
              falkor = {
                url = "github:Team-Falkor/falkor";
                inputs.nixpkgs.follows = "nixpkgs";
              };
            ''
          else
            ""
        }

        ${
          if (hyprland) then
            ''
              hyprlux = {
                url = "github:amadejkastelic/Hyprlux";
                inputs.nixpkgs.follows = "nixpkgs";
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
          home-manager,
          nerivations,
          nixpkgs,
          pipewire-screenaudio,
          self,
          shell-in-netns,
          ${concatImapStrings (i: channel: ''${channel},'') channels}
          ${if (aagl) then ''aagl,'' else ""}
          ${if (falkor) then ''falkor,'' else ""}
          ${if (hyprland) then ''hyprlux,'' else ""}
          ${if (kernel || steam-session) then ''chaotic,'' else ""}
          ${if (php) then ''phps,'' else ""}
          ${if (steam-session) then ''steam-session,'' else ""}
          ${if (suyu) then ''suyu,'' else ""}
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

              # Symlink configuration state on "/run/current-system/source"
              {
                # Source: https://github.com/NixOS/nixpkgs/blob/5e4fbfb6b3de1aa2872b76d49fafc942626e2add/nixos/modules/system/activation/top-level.nix#L191
                system.extraSystemBuilderCmds = "ln -s ''${self} $out/source";
              }

              # Internal modules
              ./modules.nix

              # External modules
              ${
                if (kernel || steam-session) then
                  ''
                    chaotic.nixosModules.default
                  ''
                else
                  ""
              }

              home-manager.nixosModules.home-manager
              nerivations.nixosModules.default

              ${concatImapStrings (
                i: channel:
                ''({config, ...}: { nixpkgs.config.packageOverrides.${channel} = import ${channel} { config = config.nixpkgs.config; }; })''
              ) channels}

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
                    hyprlux.nixosModules.default
                    ./system/desktop/hyprland
                    ./system/applications/modules/hyprlux
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
