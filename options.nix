{ lib, ... }:

{
  options = with lib; {
    icedos = {
      applications = {
        android-tools = mkOption { type = types.bool; };
        brave = mkOption { type = types.bool; };
        celluloid = mkOption { type = types.bool; };
        clamav = mkOption { type = types.bool; }; # Antivirus

        codium = {
          enable = mkOption { type = types.bool; };
          extensions = mkOption { type = with types; listOf str; };
          zoomLevel = mkOption { type = types.number; };
        };

        emulators = {
          switch = mkOption { type = types.bool; };
          wiiu = mkOption { type = types.bool; };
        };

        kitty = {
          enable = mkOption { type = types.bool; };
          hideDecorations = mkOption { type = types.bool; };
        };

        mangohud = mkOption { type = types.bool; };

        librewolf = {
          enable = mkOption { type = types.bool; };
          overrides = mkOption { type = types.bool; };
          privacy = mkOption { type = types.bool; };

          pwas = {
            enable = mkOption { type = types.bool; };
            sites = mkOption { type = with types; listOf str; };
          };
        };

        nvchad = mkOption { type = types.bool; };

        steam = {
          enable = mkOption { type = types.bool; };
          beta = mkOption { type = types.bool; };
          downloadsWorkaround = mkOption { type = types.bool; };

          session = {
            enable = mkOption { type = types.bool; };

            autoStart = {
              enable = mkOption { type = types.bool; };
              desktopSession = mkOption { type = types.str; };
            };

            useValveKernel = mkOption { type = types.bool; };
          };
        };

        sunshine = mkOption { type = types.bool; };

        tailscale = {
          enable = mkOption { type = types.bool; };
          enableTrayscale = mkOption { type = types.bool; };
        };

        valent.deviceId = mkOption { type = types.str; };
      };

      bootloader = {
        animation = mkOption { type = types.bool; };

        grub = {
          enable = mkOption { type = types.bool; };
          device = mkOption { type = types.str; };
        };

        systemd-boot = {
          enable = mkOption { type = types.bool; };
          mountPoint = mkOption { type = types.str; };
        };
      };

      desktop = {
        autologin = {
          enable = mkOption { type = types.bool; };
          user = mkOption { type = types.str; };
        };

        gdm = {
          enable = mkOption { type = types.bool; };
          autoSuspend = mkOption { type = types.bool; };
        };

        gnome = {
          enable = mkOption { type = types.bool; };

          extensions = {
            arcmenu = mkOption { type = types.bool; };
            dashToPanel = mkOption { type = types.bool; };
            gsconnect = mkOption { type = types.bool; };
          };

          clock = {
            date = mkOption { type = types.bool; };
            weekday = mkOption { type = types.bool; };
          };

          hotCorners = mkOption { type = types.bool; };
          powerButtonAction = mkOption { type = types.str; };
          startupItems = mkOption { type = types.bool; };
          titlebarLayout = mkOption { type = types.str; };

          workspaces = {
            dynamicWorkspaces = mkOption { type = types.bool; };
            maxWorkspaces = mkOption { type = types.number; };
          };
        };

        hyprland = {
          enable = mkOption { type = types.bool; };
          backlight = mkOption { type = types.str; };

          lock = {
            secondsToLowerBrightness = mkOption { type = types.number; };
            cpuUsageThreshold = mkOption { type = types.number; };
            diskUsageThreshold = mkOption { type = types.number; };
            networkUsageThreshold = mkOption { type = types.number; };
          };
        };
      };

      hardware = {
        btrfs.compression = {
          enable = mkOption { type = types.bool; };
          mounts = mkOption { type = types.bool; };
          root = mkOption { type = types.bool; };
        };

        cpus = {
          amd = {
            enable = mkOption { type = types.bool; };

            undervolt = {
              enable = mkOption { type = types.bool; };
              value = mkOption { type = types.str; };
            };
          };

          intel = mkOption {
            type = types.bool;
            default = false;
          };
        };

        devices = {
          laptop = mkOption { type = types.bool; };

          server = {
            enable = mkOption { type = types.bool; };
            dns = mkOption { type = types.str; };
            gateway = mkOption { type = types.str; };
            interface = mkOption { type = types.str; };
            ip = mkOption { type = types.str; };
          };

          steamdeck = mkOption { type = types.bool; };
        };

        gpus = {
          amd = mkOption { type = types.bool; };

          nvidia = {
            enable = mkOption { type = types.bool; };
            beta = mkOption { type = types.bool; };

            powerLimit = {
              enable = mkOption { type = types.bool; };
              value = mkOption { type = types.number; };
            };
          };
        };

        monitors = {
          a = {
            enable = mkOption { type = types.bool; };
            deck = mkOption { type = types.bool; };
            name = mkOption { type = types.str; };
            resolution = mkOption { type = types.str; };
            refreshRate = mkOption { type = types.number; };
            position = mkOption { type = types.str; };
            scaling = mkOption { type = types.number; };
            rotation = mkOption { type = types.number; };
          };

          b = {
            enable = mkOption { type = types.bool; };
            deck = mkOption { type = types.bool; };
            name = mkOption { type = types.str; };
            resolution = mkOption { type = types.str; };
            refreshRate = mkOption { type = types.number; };
            position = mkOption { type = types.str; };
            scaling = mkOption { type = types.number; };
            rotation = mkOption { type = types.number; };
          };

          c = {
            enable = mkOption { type = types.bool; };
            deck = mkOption { type = types.bool; };
            name = mkOption { type = types.str; };
            resolution = mkOption { type = types.str; };
            refreshRate = mkOption { type = types.number; };
            position = mkOption { type = types.str; };
            scaling = mkOption { type = types.number; };
            rotation = mkOption { type = types.number; };
          };

          d = {
            enable = mkOption { type = types.bool; };
            deck = mkOption { type = types.bool; };
            name = mkOption { type = types.str; };
            resolution = mkOption { type = types.str; };
            refreshRate = mkOption { type = types.number; };
            position = mkOption { type = types.str; };
            scaling = mkOption { type = types.number; };
            rotation = mkOption { type = types.number; };
          };
        };

        networking = {
          hostname = mkOption { type = types.str; };
          hosts = mkOption { type = types.bool; };
          ipv6 = mkOption { type = types.bool; };
        };

        mounts = mkOption { type = types.bool; };
      };

      system = {
        config.version = mkOption { type = types.str; };

        generations = {
          bootEntries = mkOption { type = types.number; };

          garbageCollect = {
            days = mkOption { type = types.number; };
            generations = mkOption { type = types.number; };
          };
        };

        home = mkOption { type = types.str; };

        swappiness = mkOption { type = types.number; };

        users = {
          main = {
            enable = mkOption { type = types.bool; };
            username = mkOption { type = types.str; };
            description = mkOption { type = types.str; };

            applications = {
              codium = {
                autoSave = mkOption { type = types.str; };
                formatOnSave = mkOption { type = types.bool; };
                formatOnPaste = mkOption { type = types.bool; };
              };

              git = {
                username = mkOption { type = types.str; };
                email = mkOption { type = types.str; };
              };

              nvchad.formatOnSave = mkOption { type = types.bool; };
            };

            desktop = {
              gnome.pinnedApps = {
                arcmenu = {
                  enable = mkOption { type = types.bool; };
                  list = mkOption { type = with types; listOf str; };
                };

                shell = {
                  enable = mkOption { type = types.bool; };
                  list = mkOption { type = with types; listOf str; };
                };
              };

              idle = {
                lock = {
                  enable = mkOption { type = types.bool; };
                  seconds = mkOption { type = types.number; };
                };

                disableMonitors = {
                  enable = mkOption { type = types.bool; };
                  seconds = mkOption { type = types.number; };
                };

                suspend = {
                  enable = mkOption { type = types.bool; };
                  seconds = mkOption { type = types.number; };
                };
              };
            };
          };

          server = {
            enable = mkOption { type = types.bool; };
            username = mkOption { type = types.str; };
            description = mkOption { type = types.str; };

            applications = {
              codium = {
                autoSave = mkOption { type = types.str; };
                formatOnSave = mkOption { type = types.bool; };
                formatOnPaste = mkOption { type = types.bool; };
              };

              git = {
                username = mkOption { type = types.str; };
                email = mkOption { type = types.str; };
              };

              nvchad.formatOnSave = mkOption { type = types.bool; };
            };

            desktop = {
              gnome.pinnedApps = {
                arcmenu = {
                  enable = mkOption { type = types.bool; };
                  list = mkOption { type = with types; listOf str; };
                };
                shell = {
                  enable = mkOption { type = types.bool; };
                  list = mkOption { type = with types; listOf str; };
                };
              };

              idle = {
                lock = {
                  enable = mkOption { type = types.bool; };
                  seconds = mkOption { type = types.number; };
                };

                disableMonitors = {
                  enable = mkOption { type = types.bool; };
                  seconds = mkOption { type = types.number; };
                };

                suspend = {
                  enable = mkOption { type = types.bool; };
                  seconds = mkOption { type = types.number; };
                };
              };
            };
          };

          work = {
            enable = mkOption { type = types.bool; };
            username = mkOption { type = types.str; };
            description = mkOption { type = types.str; };

            applications = {
              codium = {
                autoSave = mkOption { type = types.str; };
                formatOnSave = mkOption { type = types.bool; };
                formatOnPaste = mkOption { type = types.bool; };
              };

              git = {
                username = mkOption { type = types.str; };
                email = mkOption { type = types.str; };
              };

              nvchad.formatOnSave = mkOption { type = types.bool; };
            };

            desktop = {
              gnome.pinnedApps = {
                arcmenu = {
                  enable = mkOption { type = types.bool; };
                  list = mkOption { type = with types; listOf str; };
                };
                shell = {
                  enable = mkOption { type = types.bool; };
                  list = mkOption { type = with types; listOf str; };
                };
              };

              idle = {
                lock = {
                  enable = mkOption { type = types.bool; };
                  seconds = mkOption { type = types.number; };
                };

                disableMonitors = {
                  enable = mkOption { type = types.bool; };
                  seconds = mkOption { type = types.number; };
                };

                suspend = {
                  enable = mkOption { type = types.bool; };
                  seconds = mkOption { type = types.number; };
                };
              };
            };
          };
        };

        virtualisation = {
          containerManager = {
            enable = mkOption { type = types.bool; };
            usePodman = mkOption { type = types.bool; };
          };

          libvirtd = mkOption { type = types.bool; };
          waydroid = mkOption { type = types.bool; };
        };

        version = mkOption { type = types.str; };
      };
    };
  };

  config = builtins.fromTOML (lib.fileContents ./config.toml);
}
