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

  chaotic = (
    cfg.hardware.drivers.mesa.unstable
    || cfg.system.kernel == "cachyos"
    || cfg.system.kernel == "cachyos-server"
    || cfg.system.kernel == "valve"
    || steam-session
  );

  librewolf = cfg.applications.librewolf;
  server = cfg.hardware.devices.server;
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
        # Package repositories
        ${
          if (chaotic) then
            ''
              chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
            ''
          else
            ""
        }

        nixpkgs.${
          if (chaotic) then
            ''follows = "chaotic/nixpkgs";''
          else
            ''url = "github:NixOS/nixpkgs/nixos-unstable";''
        }

        ${concatImapStrings (
          i: channel: ''"${channel}".url = github:NixOS/nixpkgs/${channel};''\n''
        ) channels}

        # Modules
        home-manager = {
          url = "github:nix-community/home-manager";

          ${
            if (chaotic) then
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
              steam-session.follows = "chaotic/jovian";
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
          ${if (chaotic) then ''chaotic,'' else ""}
          ${if (librewolf) then ''pipewire-screenaudio,'' else ""}
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
                      map (dir: "/''${path}/''${dir}") ( let
                        inherit (lib) attrNames;
                      in
                        attrNames (filterAttrs (n: v: v == "directory" && !(n == "desktop" && path == ./system)) (builtins.readDir path))
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
                if (chaotic) then
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
