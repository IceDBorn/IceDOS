{ lib, ... }:

{
	options = {
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
					default = false;
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
					default = false;
				}; # /

				mounts.enable = lib.mkOption {
					type = lib.types.bool;
					default = true;
				}; # Mounted drives
			}; # Btrfs compression
		};

		# Declare users
		main.user = {
			enable = lib.mkOption {
				type = lib.types.bool;
				default = true;
			};

			username = lib.mkOption {
				type = lib.types.str;
				default = "stef";
			};

			description = lib.mkOption {
				type = lib.types.str;
				default = "Stefanos";
			};

			github = {
				username = lib.mkOption {
					type = lib.types.str;
					default = "CrazyStevenz";
				};

				email = lib.mkOption {
					type = lib.types.str;
					default = "github.ekta@aleeas.com";
				};
			};
		};

		work.user = {
			enable = lib.mkOption {
				type = lib.types.bool;
				default = true;
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
					default = "CrazyStevenz";
				};

				email = lib.mkOption {
					type = lib.types.str;
					default = "github.ekta@aleeas.com";
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
						default = "-p 0 -v 30 -f AE"; # Pstate 0, 1.25 voltage, 4400 clock speed
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

			patch.enable = lib.mkOption {
				type = lib.types.bool;
				default = true;
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
					default = true;
				};

				configuration = {
					clock-date.enable = lib.mkOption {
						type = lib.types.bool;
						default = true;
					};

					caffeine.enable = lib.mkOption {
						type = lib.types.bool;
						default = false;
					};

					startup-items.enable = lib.mkOption {
						type = lib.types.bool;
						default = true;
					};

					pinned-apps = {
						arcmenu.enable = lib.mkOption {
							type = lib.types.bool;
							default = true;
						};

						dash-to-panel.enable = lib.mkOption {
							type = lib.types.bool;
							default = true;
						};
					};
				};
			};

			hyprland.enable = lib.mkOption {
				type = lib.types.bool;
				default = false;
			};

			gdm.auto-suspend.enable = lib.mkOption {
				type = lib.types.bool;
				default = false;
			};
		};

		firefox-privacy.enable = lib.mkOption {
			type = lib.types.bool;
			default = false;
		};

		steam.beta.enable = lib.mkOption {
			type = lib.types.bool;
			default = true;
		};

		local.cache.enable = lib.mkOption {
			type = lib.types.bool;
			default = false;
		};
	};
}
