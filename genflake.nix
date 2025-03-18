let
  inherit (lib)
    attrNames
    boolToString
    concatImapStrings
    fileContents
    pathExists
    ;

  cfg = (import ./options.nix { inherit lib; }).config.icedos;
  lib = import <nixpkgs/lib>;

  aagl = cfg.applications.aagl;
  channels = cfg.system.channels;
  configurationLocation = fileContents "/tmp/configuration-location";
  gnome = cfg.desktop.gnome.enable;
  hyprland = cfg.desktop.hyprland.enable;
  isFirstBuild = !pathExists "/run/current-system/source" || cfg.system.forceFirstBuild;

  kernel =
    cfg.system.kernel == "cachyos"
    || cfg.system.kernel == "cachyos-server"
    || cfg.system.kernel == "valve";

  librewolf = cfg.applications.librewolf;
  php = cfg.applications.php || (cfg.applications.httpd.enable && cfg.applications.httpd.php.enable);
  server = cfg.hardware.devices.server.enable;
  steam-session = cfg.applications.steam.session.enable;
  users = attrNames cfg.system.users;
  zen-browser = cfg.applications.zen-browser.enable;

  injectIfExists =
    file:
    if (pathExists file) then
      ''
        (
          ${fileContents file}
        )
      ''
    else
      "";
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
          i: channel: ''"${channel}".url = github:NixOS/nixpkgs/${channel};''\n''
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
          if (hyprland) then
            ''
              hyprpanel = {
                url = "github:Jas-SinghFSU/HyprPanel";
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

        ${
          if (librewolf) then
            ''
              pipewire-screenaudio = {
                url = "github:IceDBorn/pipewire-screenaudio";
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
          self,
          ${if (aagl) then ''aagl,'' else ""}
          ${if (hyprland) then ''hyprpanel,'' else ""}
          ${if (kernel || steam-session) then ''chaotic,'' else ""}
          ${if (librewolf) then ''pipewire-screenaudio,'' else ""}
          ${if (php) then ''phps,'' else ""}
          ${if (steam-session) then ''steam-session,'' else ""}
          ${if (zen-browser) then ''zen-browser,'' else ""}
          ...
        }@inputs:
        {
          nixosConfigurations."${fileContents "/etc/hostname"}" = nixpkgs.lib.nixosSystem rec {
            system = "x86_64-linux";

            specialArgs = {
              inherit inputs;
            };

            modules = [
              # Read configuration location
              (
                { lib, ... }:
                let
                  inherit (lib) mkOption types;
                in
                {
                  options.icedos.configurationLocation = mkOption {
                    type = types.str;
                    default = "${configurationLocation}";
                  };
                }
              )

              # Symlink configuration state on "/run/current-system/source"
              {
                # Source: https://github.com/NixOS/nixpkgs/blob/5e4fbfb6b3de1aa2872b76d49fafc942626e2add/nixos/modules/system/activation/top-level.nix#L191
                system.extraSystemBuilderCmds = "ln -s ''${self} $out/source";
              }

              # Internal modules
              (
                { lib, ... }:
                let
                    inherit (lib) filterAttrs;

                    getModules =
                      path:
                      builtins.map (dir: "/''${path}/''${dir}") (
                        builtins.attrNames (filterAttrs (n: v: v == "directory" && !(n == "desktop" && path == ./system)) (builtins.readDir path))
                      );
                in
                {
                  imports = [
                    ./hardware
                    ./internals.nix
                    ./options.nix
                  ] ++ getModules (./system) ++ getModules (./hardware);

                  config.system.stateVersion = "${cfg.system.version}";
                }
              )

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

              ${concatImapStrings (i: channel: ''
                (
                  {config, ...}: {
                    nixpkgs.config.packageOverrides."${channel}" = import inputs."${channel}" {
                      inherit system;
                      config = config.nixpkgs.config;
                    };
                  }
                )
              '') channels}

              ${
                if (!server) then
                  ''
                    ./system/desktop
                  ''
                else
                  ""
              }

              # Is First Build
              { icedos.internals.isFirstBuild = ${boolToString (isFirstBuild)}; }

              ${
                if (steam-session && !isFirstBuild) then
                  ''
                    steam-session.nixosModules.default
                    ./system/desktop/steam-session
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
                    ./system/desktop/hyprland
                    { nixpkgs.overlays = [ hyprpanel.overlay ]; }
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

              ${if (zen-browser) then "./system/applications/modules/zen-browser" else ""}

              ${concatImapStrings (
                i: user:
                if (pathExists "${configurationLocation}/system/users/${user}") then
                  "./system/users/${user}\n"
                else
                  ""
              ) users}

              ${injectIfExists "/etc/nixos/hardware-configuration.nix"}
              ${injectIfExists "/etc/nixos/extras.nix"}
            ];
          };
        };
    }
  '';
}
