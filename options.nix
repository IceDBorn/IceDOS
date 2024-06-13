{ lib, ... }:

let
  users = {
    main = {
      username = "icedborn";
      description = "IceDBorn";
    };

    work = {
      username = "work";
      description = "Work";
    };
  };
in
{
  options = with lib; {
    icedos = {
      applications = {
        android-tools = mkOption { type = types.bool; };
        brave = mkOption { type = types.bool; };

        codium = {
          enable = mkOption { type = types.bool; };
          extensions = mkOption { type = with types; listOf str; };
          zoomLevel = mkOption { type = types.number; };
        };

        kitty.hideDecorations = mkOption { type = types.bool; };

        librewolf = {
          enable = mkOption { type = types.bool; };
          overrides = mkOption { type = types.bool; };
          privacy = mkOption { type = types.bool; };
          pwas = mkOption { type = with types; listOf str; };
        };

        nvchad = mkOption { type = types.bool; };

        steam = {
          beta = mkOption { type = types.bool; };
          downloadsWorkaround = mkOption { type = types.bool; };

          session = {
            enable = mkOption { type = types.bool; };

            autoStart = {
              enable = mkOption { type = types.bool; };
              desktopSession = mkOption { type = types.str; };
            };
          };
        };

        sunshine = mkOption { type = types.bool; };

        emulators = {
          switch = mkOption { type = types.bool; };
          wiiu = mkOption { type = types.bool; };
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
          main = {
            enable = mkOption { type = types.bool; };
            deck = mkOption { type = types.bool; };
            name = mkOption { type = types.str; };
            resolution = mkOption { type = types.str; };
            refreshRate = mkOption { type = types.number; };
            position = mkOption { type = types.str; };
            scaling = mkOption { type = types.number; };
            rotation = mkOption { type = types.number; };
          };

          second = {
            enable = mkOption { type = types.bool; };
            deck = mkOption { type = types.bool; };
            name = mkOption { type = types.str; };
            resolution = mkOption { type = types.str; };
            refreshRate = mkOption { type = types.number; };
            position = mkOption { type = types.str; };
            scaling = mkOption { type = types.number; };
            rotation = mkOption { type = types.number; };
          };

          third = {
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

        virtualisation = {
          docker = mkOption { type = types.bool; };
          libvirtd = mkOption { type = types.bool; };
          lxd = mkOption { type = types.bool; };
          spiceUSBRedirection = mkOption { type = types.bool; };
          waydroid = mkOption { type = types.bool; };
        };
      };

      system = {
        config.version = mkOption {
          type = types.str;
          default = "1.0.0";
        };

        generations = {
          bootEntries = mkOption {
            type = types.number;
            default = 10;
          };

          garbageCollect = {
            # Number of days before a generation can be deleted
            days = mkOption {
              type = types.str;
              default = "0";
            };

            # Number of generations that will always be kept
            generations = mkOption {
              type = types.str;
              default = "10";
            };
          };
        };

        home = mkOption {
          type = types.str;
          default = "/home";
        };

        swappiness = mkOption {
          type = types.str;
          default = "1";
        };

        user = {
          main = {
            enable = mkOption {
              type = types.bool;
              default = true;
            };

            username = mkOption {
              type = types.str;
              default = users.main.username;
            };

            description = mkOption {
              type = types.str;
              default = users.main.description;
            };

            applications = {
              codium = {
                # off, afterDelay, onFocusChange, onWindowChange
                autoSave = mkOption {
                  type = types.str;
                  default = "off";
                };

                formatOnSave = mkOption {
                  type = types.str;
                  default = "true";
                };

                formatOnPaste = mkOption {
                  type = types.str;
                  default = "true";
                };
              };

              git = {
                username = mkOption {
                  type = types.str;
                  default = "IceDBorn";
                };

                email = mkOption {
                  type = types.str;
                  default = "git.outsider841@simplelogin.fr";
                };
              };

              nvchad.formatOnSave = mkOption {
                type = types.bool;
                default = true;
              };
            };

            desktop = {
              gnome.pinnedApps = {
                arcmenu = {
                  enable = mkOption {
                    type = types.bool;
                    default = false;
                  };

                  list = mkOption {
                    type = with types; listOf str;
                    default = [
                      "Codium IDE"
                      ""
                      "codiumIDE.desktop"
                      "VSCodium"
                      ""
                      "codium.desktop"
                      "Spotify"
                      ""
                      "spotify.desktop"
                      "Mullvad VPN"
                      ""
                      "mullvad-vpn.desktop"
                      "GNU Image Manipulation Program"
                      ""
                      "gimp.desktop"
                    ];
                  };
                };

                # Set pinned apps for gnome shell (will be used by dash-to-panel if enabled)
                shell = {
                  enable = mkOption {
                    type = types.bool;
                    default = false;
                  };

                  list = mkOption {
                    type = with types; listOf str;
                    default = [
                      "steam.desktop"
                      "webcord.desktop"
                      "signal-desktop.desktop"
                      "librewolf.desktop"
                    ];
                  };
                };
              };

              idle = {
                lock = {
                  enable = mkOption {
                    type = types.bool;
                    default = true;
                  };

                  seconds = mkOption {
                    type = types.str;
                    default = "180";
                  };
                };

                disableMonitors = {
                  enable = mkOption {
                    type = types.bool;
                    default = true;
                  };

                  seconds = mkOption {
                    type = types.str;
                    default = "300";
                  };
                };

                suspend = {
                  enable = mkOption {
                    type = types.bool;
                    default = true;
                  };

                  seconds = mkOption {
                    type = types.str;
                    default = "900";
                  };
                };
              };
            };
          };

          work = {
            enable = mkOption {
              type = types.bool;
              default = false;
            };

            username = mkOption {
              type = types.str;
              default = users.work.username;
            };

            description = mkOption {
              type = types.str;
              default = users.work.description;
            };

            applications = {
              codium = {
                # off, afterDelay, onFocusChange, onWindowChange
                autoSave = mkOption {
                  type = types.str;
                  default = "off";
                };

                formatOnSave = mkOption {
                  type = types.str;
                  default = "false";
                };

                formatOnPaste = mkOption {
                  type = types.str;
                  default = "false";
                };
              };

              git = {
                username = mkOption {
                  type = types.str;
                  default = "IceDBorn";
                };

                email = mkOption {
                  type = types.str;
                  default = "git.outsider841@simplelogin.fr";
                };
              };

              nvchad.formatOnSave = mkOption {
                type = types.bool;
                default = false;
              };
            };

            desktop = {
              gnome.pinnedApps = {
                arcmenu = {
                  enable = mkOption {
                    type = types.bool;
                    default = false;
                  };

                  list = mkOption {
                    type = with types; listOf str;
                    default = [
                      "Codium IDE"
                      ""
                      "codiumIDE.desktop"
                      "VSCodium"
                      ""
                      "codium.desktop"
                      "Spotify"
                      ""
                      "spotify.desktop"
                      "Mullvad VPN"
                      ""
                      "mullvad-vpn.desktop"
                      "GNU Image Manipulation Program"
                      ""
                      "gimp.desktop"
                    ];
                  };
                };

                # Set pinned apps for gnome shell (will be used by dash-to-panel if enabled)
                shell = {
                  enable = mkOption {
                    type = types.bool;
                    default = false;
                  };

                  list = mkOption {
                    type = with types; listOf str;
                    default = [
                      "slack.desktop"
                      "webcord.desktop"
                      "signal-desktop.desktop"
                      "librewolf.desktop"
                      "webstorm.desktop"
                    ];
                  };
                };
              };

              idle = {
                lock = {
                  enable = mkOption {
                    type = types.bool;
                    default = true;
                  };

                  seconds = mkOption {
                    type = types.str;
                    default = "180";
                  };
                };

                disableMonitors = {
                  enable = mkOption {
                    type = types.bool;
                    default = true;
                  };

                  seconds = mkOption {
                    type = types.str;
                    default = "300";
                  };
                };

                suspend = {
                  enable = mkOption {
                    type = types.bool;
                    default = true;
                  };

                  seconds = mkOption {
                    type = types.str;
                    default = "900";
                  };
                };
              };
            };
          };
        };

        # Do not change without checking the docs (config.system.stateVersion)
        version = mkOption {
          type = types.str;
          default = "23.05";
        };
      };
    };
  };

  config = builtins.fromJSON (lib.fileContents ./config.json);
}
