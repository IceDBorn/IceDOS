{ lib, config, pkgs, ... }:

{
  imports =
    [ ./home-main.nix ./home-work.nix ]; # Setup home manager for hyprland

  environment = lib.mkIf config.desktop-environment.hyprland.enable {
    systemPackages = with pkgs; [
      (callPackage ../../../programs/self-built/hyprland-per-window-layout.nix
        { })
      # Status bar
      (waybar.overrideAttrs (oldAttrs: {
        mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
        postPatch = ''
          sed -i 's/zext_workspace_handle_v1_activate(workspace_handle_);/const std::string command = "hyprctl dispatch workspace " + name_;\n\tsystem(command.c_str());/g' src/modules/wlr/workspace_manager.cpp
        '';
      }))
      clipman # Clipboard manager for wayland
      hyprpaper # Wallpaper daemon
      rofi-wayland # App launcher
      slurp # Monitor selector
      wdisplays # Displays manager
      wl-clipboard # Clipboard daemon
      wlogout # Logout screen
    ];

    etc = lib.mkIf config.desktop-environment.hyprland.enable {
      "wlogout-icons".source = "${pkgs.wlogout}/share/wlogout/icons";
    };
  };

  disabledModules = [ "programs/hyprland.nix" ]; # Needed for hyprland flake
}
