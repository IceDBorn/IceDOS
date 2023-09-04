{ lib, ... }:

{
  options = {
    state-version = lib.mkOption {
      type = lib.types.str;
      default = "23.05";
    }; # Do not change without checking the docs (config.system.stateVersion)

    efi-mount-path = lib.mkOption {
      type = lib.types.str;
      default = "/boot";
    };

    mounts.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
    }; # Set to false if hardware/mounts.nix is not correctly configured

    boot = {
      animation.enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
      }; # Hides startup text and displays a circular loading icon

      autologin = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = true;
        };

        main.user.enable = lib.mkOption {
          type = lib.types.bool;
          default = true;
        }; # If false, defaults to work user
      };

      windows-entry = lib.mkOption {
        type = lib.types.str;
        default = "0000";
      }; # Used for rebooting to windows with efibootmgr

      btrfs-compression = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = true;
        };

        root.enable = lib.mkOption {
          type = lib.types.bool;
          default = true;
        }; # /

        mounts.enable = lib.mkOption {
          type = lib.types.bool;
          default = true;
        }; # Mounted drives
      }; # Btrfs compression
    };

    gc = {
      generations = lib.mkOption {
        type = lib.types.str;
        default = "10";
      }; # Number of generations that will always be kept

      days = lib.mkOption {
        type = lib.types.str;
        default = "0";
      }; # Number of days before a generation can be deleted
    };

    # Declare users
    main.user = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };

      username = lib.mkOption {
        type = lib.types.str;
        default = "icedborn";
      };

      description = lib.mkOption {
        type = lib.types.str;
        default = "IceDBorn";
      };

      github = {
        username = lib.mkOption {
          type = lib.types.str;
          default = "IceDBorn";
        };

        email = lib.mkOption {
          type = lib.types.str;
          default = "github.envenomed@dralias.com";
        };
      };
    };

    work.user = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };

      username = lib.mkOption {
        type = lib.types.str;
        default = "work";
      };

      description = lib.mkOption {
        type = lib.types.str;
        default = "Work";
      };

      github = {
        username = lib.mkOption {
          type = lib.types.str;
          default = "IceDBorn";
        };

        email = lib.mkOption {
          type = lib.types.str;
          default = "github.envenomed@dralias.com";
        };
      };
    };

    amd = {
      gpu.enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };

      cpu = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = true;
        };

        undervolt = {
          enable = lib.mkOption {
            type = lib.types.bool;
            default = true;
          };

          value = lib.mkOption {
            type = lib.types.str;
            # Pstate 0, 1.25 voltage, 4200 clock speed
            default = "-p 0 -v 30 -f A8";
          };
        };
      };
    };

    nvidia = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };

      power-limit = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = true;
        };

        value = lib.mkOption {
          type = lib.types.str;
          default = "242"; # RTX 3070
        };
      };
    };

    intel.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };

    laptop.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };

    virtualisation-settings = {
      docker.enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
      }; # Container manager

      libvirtd.enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
      }; # A daemon that manages virtual machines

      lxd.enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
      }; # Container daemon

      spiceUSBRedirection.enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
      }; # Passthrough USB devices to vms

      waydroid.enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
      }; # Android container
    };

    desktop-environment = {
      gnome = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = false;
        };

        arcmenu.enable = lib.mkOption {
          type = lib.types.bool;
          default = false;
        };

        caffeine.enable = lib.mkOption {
          type = lib.types.bool;
          default = true;
        };

        clock-date.enable = lib.mkOption {
          type = lib.types.bool;
          default = false;
        };

        dash-to-panel.enable = lib.mkOption {
          type = lib.types.bool;
          default = false;
        };

        gsconnect.enable = lib.mkOption {
          type = lib.types.bool;
          default = true;
        };

        hot-corners.enable = lib.mkOption {
          type = lib.types.bool;
          default = false;
        };

        pinned-apps.enable = lib.mkOption {
          type = lib.types.bool;
          default = false;
        }; # Whether to set (or unset) gnome's and arcmenu's pinned apps

        startup-items.enable = lib.mkOption {
          type = lib.types.bool;
          default = false;
        };
      };

      hypr = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = true;
        };
      };

      hyprland = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = true;
        };

        dual-monitor.enable = lib.mkOption {
          type = lib.types.bool;
          default = true;
        };
      };

      steam = {
        beta.enable = lib.mkOption {
          type = lib.types.bool;
          default = true;
        };

        session.enable = lib.mkOption {
          type = lib.types.bool;
          default = true;
        };
      };

      gdm.auto-suspend.enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };
    };

    firefox = {
      privacy.enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };

      gnome-theme.enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };

      # Sites to launch on Firefox PWAs
      pwas.sites = lib.mkOption {
        type = lib.types.str;
        default =
          "https://mail.tutanota.com https://icedborn.github.io/icedchat https://discord.com/app";
      };
    };

    xpadneo-unstable.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
    }; # use self-built version of xpadneo to fix some controller issues

    # Hide kitty top bar
    kitty.hide-decorations = lib.mkOption {
      type = lib.types.bool;
      default = true;
    };

    # Extras to use for adwaita for steam theme
    adwaita-for-steam.extras = lib.mkOption {
      type = lib.types.str;
      default =
        "-e library/hide_whats_new -e library/sidebar_hover -e login/hover_qr -e windowcontrols/hide-close";
    };
  };
}
