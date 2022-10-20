{ config, pkgs, ... }:
let
    flake-compat = builtins.fetchTarball "https://github.com/edolstra/flake-compat/archive/master.tar.gz";
    hyprland = (import flake-compat {
        src = builtins.fetchTarball "https://github.com/hyprwm/Hyprland/archive/master.tar.gz";
    }).defaultNix;

    dbus-hypr-environment = pkgs.writeTextFile {
        name = "dbus-hypr-environment";
        destination = "/bin/dbus-hypr-environment";
        executable = true;

        text = ''
            dbus-update-activation-environment --systemd XDG_SESSION_TYPE=wayland WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=sway DBUS_SESSION_BUS_ADDRESS DISPLAY XAUTHORITY
            systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
            systemctl --user stop pipewire wireplumber xdg-desktop-portal xdg-desktop-portal-wlr
            systemctl --user start pipewire wireplumber xdg-desktop-portal xdg-desktop-portal-wlr
        '';
    };
in
{
    imports = [ hyprland.nixosModules.default ];

    programs = {
        nm-applet.enable = true;
        hyprland = {
            enable = true;
            package = hyprland.packages.${pkgs.system}.default.override {
                wlroots = hyprland.packages.${pkgs.system}.wlroots-hyprland.overrideAttrs(old: {
                    patches = (old.patches or []) ++ [
                        (pkgs.fetchpatch {
                            url = "https://aur.archlinux.org/cgit/aur.git/plain/0001-nvidia-format-workaround.patch?h=hyprland-nvidia-screenshare-git";
                            sha256 = "A9f1p5EW++mGCaNq8w7ZJfeWmvTfUm4iO+1KDcnqYX8=";
                        })
                    ];
                });
            };
        };
    };

    nixpkgs.overlays = [
        (self: super: {
            waybar = super.waybar.overrideAttrs (oldAttrs: {
                mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
            });
        })
    ];

    environment = {
        sessionVariables = {
            LIBVA_DRIVER_NAME = "nvidia";
            GBM_BACKEND = "nvidia-drm";
            __GLX_VENDOR_LIBRARY_NAME = "nvidia";
            WLR_NO_HARDWARE_CURSORS = "1";
        };

        systemPackages = with pkgs; [
            blueberry # Bluetooth manager
            dbus-hypr-environment # Run specific commands
            grim # Screenshot tool
            networkmanagerapplet # Network manager tray icon
            pavucontrol # Sound manager
            rofi-wayland # App launcher
            slurp # Monitor selector
            waybar # Status bar
            wdisplays # Displays manager
            wl-clipboard # Clipboard daemon
            wlogout # Logout screen
        ];
    };

    services.dbus.enable = true;

    xdg.portal = {
        enable = true;
        extraPortals = [
            pkgs.xdg-desktop-portal
            pkgs.xdg-desktop-portal-wlr
        ];
        wlr = {
            enable = true;
            settings.screencast = {
                chooser_type = "simple";
                chooser_cmd = "${pkgs.slurp}/bin/slurp -f %o -or";
            };
        };
    };
}