{ lib, ... }:

{
  options = with lib; {
    applications = {
      firefox = {
        gnome-theme.enable = mkOption {
          type = types.bool;
          default = true;
        };

        privacy.enable = mkOption {
          type = types.bool;
          default = true;
        };

        # Sites to launch on Firefox PWAs
        pwas.sites = mkOption {
          type = types.str;
          default =
            "https://mail.tutanota.com https://icedborn.github.io/icedchat https://discord.com/app";
        };
      };

      # Hide kitty top bar
      kitty.hide-decorations = mkOption {
        type = types.bool;
        default = true;
      };

      steam = {
        # Extras to use for adwaita for steam theme
        adwaita-for-steam.extras = mkOption {
          type = types.str;
          default =
            "-e library/hide_whats_new -e login/hover_qr -e windowcontrols/hide-close";
        };

        beta.enable = mkOption {
          type = types.bool;
          default = true;
        };

        # Workaround for slow steam downloads
        downloads-workaround.enable = mkOption {
          type = types.bool;
          default = true;
        };

        session.enable = mkOption {
          type = types.bool;
          default = true;
        };
      };
    };

    boot = {
      # Hides startup text and displays a circular loading icon
      animation.enable = mkOption {
        type = types.bool;
        default = false;
      };

      efi-mount-path = mkOption {
        type = types.str;
        default = "/boot";
      };

      # Used for rebooting to windows with efibootmgr
      windows-entry = mkOption {
        type = types.str;
        default = "0000";
      };
    };

    desktop = {
      autologin = {
        enable = mkOption {
          type = types.bool;
          default = true;
        };

        # If false, defaults to work user
        main.user.enable = mkOption {
          type = types.bool;
          default = true;
        };
      };

      gdm.auto-suspend.enable = mkOption {
        type = types.bool;
        default = false;
      };

      gnome = {
        enable = mkOption {
          type = types.bool;
          default = false;
        };

        arcmenu.enable = mkOption {
          type = types.bool;
          default = false;
        };

        caffeine.enable = mkOption {
          type = types.bool;
          default = true;
        };

        clock-date.enable = mkOption {
          type = types.bool;
          default = false;
        };

        dash-to-panel.enable = mkOption {
          type = types.bool;
          default = false;
        };

        gsconnect.enable = mkOption {
          type = types.bool;
          default = true;
        };

        hot-corners.enable = mkOption {
          type = types.bool;
          default = false;
        };

        # Whether to set (or unset) gnome's and arcmenu's pinned apps
        pinned-apps.enable = mkOption {
          type = types.bool;
          default = false;
        };

        startup-items.enable = mkOption {
          type = types.bool;
          default = false;
        };

        workspaces = {
          dynamic-workspaces.enable = mkOption {
            type = types.bool;
            default = true;
          };

          # Determines the maximum number of workspaces when dynamic workspaces are disabled
          max-workspaces = mkOption {
            type = types.str;
            default = "1";
          };
        };
      };

      hypr.enable = mkOption {
        type = types.bool;
        default = true;
      };

      hyprland.enable = mkOption {
        type = types.bool;
        default = true;
      };
    };

    hardware = {
      btrfs-compression = {
        enable = mkOption {
          type = types.bool;
          default = true;
        };

        # Use btrfs compression for mounted drives
        mounts.enable = mkOption {
          type = types.bool;
          default = true;
        };

        # Use btrfs compression for root
        root.enable = mkOption {
          type = types.bool;
          default = true;
        };
      };

      cpu = {
        amd = {
          enable = mkOption {
            type = types.bool;
            default = true;
          };

          undervolt = {
            enable = mkOption {
              type = types.bool;
              default = true;
            };

            value = mkOption {
              type = types.str;
              # Pstate 0, 1.25 voltage, 4200 clock speed
              default = "-p 0 -v 30 -f A8";
            };
          };
        };

        intel.enable = mkOption {
          type = types.bool;
          default = false;
        };
      };

      gpu = {
        amd.enable = mkOption {
          type = types.bool;
          default = true;
        };

        nvidia = {
          enable = mkOption {
            type = types.bool;
            default = false;
          };

          power-limit = {
            enable = mkOption {
              type = types.bool;
              default = true;
            };

            # RTX 3070
            value = mkOption {
              type = types.str;
              default = "242";
            };
          };
        };
      };

      laptop = {
        enable = mkOption {
          type = types.bool;
          default = false;
        };

        auto-cpufreq.enable = mkOption {
          type = types.bool;
          default = true;
        };
      };

      monitors = {
        main = {
          enable = mkOption {
            type = types.bool;
            default = true;
          };

          name = mkOption {
            type = types.str;
            default = "DP-1";
          };

          resolution = mkOption {
            type = types.str;
            default = "1920x1080@144";
          };

          position = mkOption {
            type = types.str;
            default = "0x0";
          };

          scaling = mkOption {
            type = types.str;
            default = "1";
          };
        };

        secondary = {
          enable = mkOption {
            type = types.bool;
            default = true;
          };

          name = mkOption {
            type = types.str;
            default = "DP-2";
          };

          resolution = mkOption {
            type = types.str;
            default = "1280x1024@75";
          };

          position = mkOption {
            type = types.str;
            default = "1920x0";
          };

          scaling = mkOption {
            type = types.str;
            default = "1";
          };
        };
      };

      # Set to false if hardware/mounts.nix is not correctly configured
      mounts.enable = mkOption {
        type = types.bool;
        default = true;
      };

      virtualisation = {
        # Container manager
        docker.enable = mkOption {
          type = types.bool;
          default = true;
        };

        # A daemon that manages virtual machines
        libvirtd.enable = mkOption {
          type = types.bool;
          default = true;
        };

        # Container daemon
        lxd.enable = mkOption {
          type = types.bool;
          default = true;
        };

        # Passthrough USB devices to vms
        spiceUSBRedirection.enable = mkOption {
          type = types.bool;
          default = true;
        };

        # Android container
        waydroid.enable = mkOption {
          type = types.bool;
          default = true;
        };
      };

      # use self-built version of xpadneo to fix some controller issues
      xpadneo-unstable.enable = mkOption {
        type = types.bool;
        default = true;
      };
    };

    system = {
      # Location of the config
      configuration-location = mkOption {
        type = types.str;
        default = builtins.readFile ./.configuration-location;
      };

      gc = {
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

      user = {
        main = {
          enable = mkOption {
            type = types.bool;
            default = true;
          };

          username = mkOption {
            type = types.str;
            default = "icedborn";
          };

          description = mkOption {
            type = types.str;
            default = "IceDBorn";
          };

          git = {
            username = mkOption {
              type = types.str;
              default = "IceDBorn";
            };

            email = mkOption {
              type = types.str;
              default = "github.envenomed@dralias.com";
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
            default = "work";
          };

          description = mkOption {
            type = types.str;
            default = "Work";
          };

          git = {
            username = mkOption {
              type = types.str;
              default = "IceDBorn";
            };

            email = mkOption {
              type = types.str;
              default = "github.envenomed@dralias.com";
            };
          };
        };
      };

      # Do not change without checking the docs (config.system.stateVersion)
      state-version = mkOption {
        type = types.str;
        default = "23.05";
      };
    };
  };
}
