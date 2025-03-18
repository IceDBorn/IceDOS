{ lib, ... }:

{
  options = with lib; {
    icedos = {
      applications = {
        aagl = mkOption { type = types.bool; };
        android-tools = mkOption { type = types.bool; };
        celluloid = mkOption { type = types.bool; };
        clamav = mkOption { type = types.bool; };

        codium = {
          enable = mkOption { type = types.bool; };
          zoomLevel = mkOption { type = types.number; };
        };

        defaultBrowser = mkOption { type = types.str; };
        defaultEditor = mkOption { type = types.str; };
        extraPackages = mkOption { type = with types; listOf str; };

        httpd = {
          enable = mkOption { type = types.bool; };

          php = {
            enable = mkOption { type = types.bool; };
            version = mkOption { type = types.str; };
          };

          user = mkOption { type = types.str; };
        };

        input-remapper = mkOption { type = types.bool; };

        kitty = {
          enable = mkOption { type = types.bool; };
          hideDecorations = mkOption { type = types.bool; };
        };

        librewolf = mkOption { type = types.bool; };

        mangohud = {
          enable = mkOption { type = types.bool; };
          maxFpsLimit = mkOption { type = types.number; };
        };

        mullvad = {
          enable = mkOption { type = types.bool; };
          gui = mkOption { type = types.bool; };
        };

        mysql = mkOption { type = types.bool; };
        nautilus = mkOption { type = types.bool; };

        network-manager = {
          enable = mkOption { type = types.bool; };
          applet = mkOption { type = types.bool; };
        };

        obs-studio = {
          enable = mkOption { type = types.bool; };
          virtualCamera = mkOption { type = types.bool; };
        };

        php = mkOption { type = types.bool; };
        pitivi = mkOption { type = types.bool; };
        protonvpn = mkOption { type = types.bool; };
        rust = mkOption { type = types.bool; };

        signal = {
          enable = mkOption { type = types.bool; };
          package = mkOption { type = types.str; };
        };

        solaar = mkOption { type = types.bool; };
        ssh = mkOption { type = types.bool; };

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

            user = mkOption { type = types.str; };
          };
        };

        sunshine = mkOption { type = types.bool; };
        suyu = mkOption { type = types.bool; };

        tailscale = {
          enable = mkOption { type = types.bool; };
          enableTrayscale = mkOption { type = types.bool; };
        };

        valent = {
          enable = mkOption { type = types.bool; };
          deviceId = mkOption { type = types.str; };
        };

        yazi = mkOption { type = types.bool; };

        zed = {
          enable = mkOption { type = types.bool; };
          ollamaSupport = mkOption { type = types.bool; };
          vim = mkOption { type = types.bool; };

          theme = {
            dark = mkOption { type = types.str; };
            light = mkOption { type = types.str; };
            mode = mkOption { type = types.str; };
          };
        };

        zen-browser = {
          enable = mkOption { type = types.bool; };
          privacy = mkOption { type = types.bool; };

          pwas = {
            enable = mkOption { type = types.bool; };
            sites = mkOption { type = with types; listOf str; };
          };
        };
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
        accentColor = mkOption { type = types.str; };

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
          accentColor = mkOption { type = types.str; };

          extensions = {
            arcmenu = mkOption { type = types.bool; };
            dashToPanel = mkOption { type = types.bool; };
          };

          clock = {
            date = mkOption { type = types.bool; };
            weekday = mkOption { type = types.bool; };
          };

          hotCorners = mkOption { type = types.bool; };
          powerButtonAction = mkOption { type = types.str; };
          titlebarLayout = mkOption { type = types.str; };

          workspaces = {
            dynamicWorkspaces = mkOption { type = types.bool; };
            maxWorkspaces = mkOption { type = types.number; };
          };
        };

        hyprland = {
          enable = mkOption { type = types.bool; };

          cs2fix = {
            enable = mkOption { type = types.bool; };
            width = mkOption { type = types.number; };
            height = mkOption { type = types.number; };
          };

          followMouse = mkOption { type = types.number; };
          hyprspace = mkOption { type = types.bool; };

          hyproled = {
            enable = mkOption { type = types.bool; };
            startWidth = mkOption { type = types.number; };
            startHeight = mkOption { type = types.number; };
            endWidth = mkOption { type = types.number; };
            endHeight = mkOption { type = types.number; };
          };

          lock = {
            secondsToLowerBrightness = mkOption { type = types.number; };
            cpuUsageThreshold = mkOption { type = types.number; };
            diskUsageThreshold = mkOption { type = types.number; };
            networkUsageThreshold = mkOption { type = types.number; };
          };

          startupScript = mkOption { type = types.str; };
          windowRules = mkOption { type = with types; listOf str; };
        };
      };

      hardware = {
        bluetooth = mkOption { type = types.bool; };

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

        drivers = {
          rtl8821ce = mkOption { type = types.bool; };
          xpadneo = mkOption { type = types.bool; };
        };

        gpus = {
          amd = {
            enable = mkOption { type = types.bool; };
            rocm = mkOption { type = types.bool; };
          };

          nvidia = {
            enable = mkOption { type = types.bool; };
            beta = mkOption { type = types.bool; };
            cuda = mkOption { type = types.bool; };
            openDrivers = mkOption { type = types.bool; };

            powerLimit = {
              enable = mkOption { type = types.bool; };
              value = mkOption { type = types.number; };
            };
          };
        };

        monitors = mkOption {
          type = types.listOf (
            types.submodule {
              options = {
                name = mkOption { type = types.str; };
                disable = mkOption { type = types.bool; };
                resolution = mkOption { type = types.str; };
                refreshRate = mkOption { type = types.number; };
                position = mkOption { type = types.str; };
                scaling = mkOption { type = types.number; };
                rotation = mkOption { type = types.number; };
                tenBit = mkOption { type = types.bool; };
              };
            }
          );
        };

        networking = {
          hostname = mkOption { type = types.str; };
          hosts = mkOption { type = types.bool; };
          ipv6 = mkOption { type = types.bool; };
          vpnExcludeIp = mkOption { type = types.str; };
        };

        mounts = mkOption { type = types.bool; };
      };

      system = {
        channels = mkOption { type = types.listOf types.str; };
        forceFirstBuild = mkOption { type = types.bool; };

        generations = {
          bootEntries = mkOption { type = types.number; };

          garbageCollect = {
            automatic = mkOption { type = types.bool; };
            days = mkOption { type = types.number; };
            generations = mkOption { type = types.number; };
            interval = mkOption { type = types.str; };
          };
        };

        home = mkOption { type = types.str; };
        kernel = mkOption { type = types.str; };
        swappiness = mkOption { type = types.number; };

        users = mkOption {
          type = types.attrsOf (
            types.submodule (_: {
              options = {
                description = mkOption { type = types.str; };
                type = mkOption { type = types.str; };

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
                };

                desktop = {
                  gnome = {
                    pinnedApps = {
                      arcmenu = {
                        enable = mkOption { type = types.bool; };
                        list = mkOption { type = with types; listOf str; };
                      };

                      shell = {
                        enable = mkOption { type = types.bool; };
                        list = mkOption { type = with types; listOf str; };
                      };
                    };

                    startupScript = mkOption { type = types.str; };
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
            })
          );
        };

        virtualisation = {
          containerManager = {
            enable = mkOption { type = types.bool; };
            usePodman = mkOption { type = types.bool; };
            requireSudoForDocker = mkOption { type = types.bool; };
          };

          virtManager = mkOption { type = types.bool; };
          waydroid = mkOption { type = types.bool; };
        };

        version = mkOption { type = types.str; };
      };
    };
  };

  config = builtins.fromTOML (lib.fileContents ./config.toml);
}
