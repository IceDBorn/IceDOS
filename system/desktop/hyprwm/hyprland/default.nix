{ lib, config, pkgs, ... }:
let
  inhibit-lock = pkgs.writeScriptBin "inhibit-lock" ''
    #!/usr/bin/env wpexec
    local INPUT = "Stream/Input/Audio"
    local OUTPUT = "Stream/Output/Audio"
    local FIREFOX_CALL = "AudioCallbackDriver"
    local INHIBIT_LOCK = false

    local nodeManager = ObjectManager({
      Interest({
        type = "node",
        Constraint({ "media.class", "in-list", OUTPUT, INPUT }),
      }),
    })

    local linkManager = ObjectManager({
      Interest({
        type = "link",
      }),
    })

    local function hasActiveLinks(nodeId, linkType)
      local constraint = Constraint({ linkType, "=", tostring(nodeId) })
      for link in linkManager:iterate({ type = "link", constraint }) do
        if link.state == "active" then
          return true
        end
      end
      return false
    end

    nodeManager:connect("installed", function(nodeManager)
      for node in nodeManager:iterate() do
        local mediaName = node.properties["media.name"]
        local mediaClass = node.properties["media.class"]
        if mediaName ~= FIREFOX_CALL or mediaClass == INPUT then
          if hasActiveLinks(node.bound_id, "link.input.node") or hasActiveLinks(node.bound_id, "link.output.node") then
            INHIBIT_LOCK = true
            break
          end
        end
      end

      print(INHIBIT_LOCK)
      Core.quit()
    end)

    linkManager:activate()
    nodeManager:activate()
  '';

  swayidleconf = pkgs.writeShellScriptBin "swayidleconf" ''
    swayidle -w timeout 180 'swaylockconf' \
            timeout 300 'if [ `inhibit-lock` = "false" ]; then hyprctl dispatch dpms off; fi'  \
            resume 'hyprctl dispatch dpms on' \
            timeout 900 'if [ `inhibit-lock` = "false" ]; then systemctl suspend; fi' \
            before-sleep 'swaylockconf' &
  '';

  swaylockconf = pkgs.writeShellScriptBin "swaylockconf" ''
    if [ `inhibit-lock` = "true" ]; then exit; fi

    swaylock --daemonize \
    --clock \
    --indicator-idle-visible \
    --fade-in 4 \
    --grace 5 \
    --screenshots \
    --effect-blur 10x10 \
    --inside-color 00000055 \
    --text-color F \
    --ring-color F \
    --effect-vignette 0.2:0.2
  '';
in {
  imports = [
    # Setup home manager for hyprland
    ./home/main.nix
    ./home/work.nix
    # Setup hyprland configs
    ./configs/config.nix
    ./configs/waybar/config.nix
  ];

  programs.hyprland = lib.mkIf config.desktop.hyprland.enable {
    enable = true;
    enableNvidiaPatches = config.hardware.gpu.nvidia.enable;
  };

  environment = lib.mkIf config.desktop.hyprland.enable {
    systemPackages = with pkgs; [
      clipman # Clipboard manager for wayland
      gnome.gnome-calendar # Calendar
      grimblast # Screenshot tool
      hyprland-per-window-layout # Per window layout
      hyprpaper # Wallpaper daemon
      inhibit-lock # Script to check if pipewire has active links
      rofi-wayland # App launcher
      slurp # Monitor selector
      swayidle # Idle inhibitor
      swayidleconf # Configure swayidle
      swaylock-effects # Lock
      swaylockconf # Configure swaylock
      waybar # Status bar
      wdisplays # Displays manager
      wl-clipboard # Clipboard daemon
      wlogout # Logout screen
    ];

    etc = lib.mkIf config.desktop.hyprland.enable {
      "wlogout-icons".source = "${pkgs.wlogout}/share/wlogout/icons";
    };
  };

  # Needed for hyprland flake
  disabledModules = [ "programs/hyprland.nix" ];

  # Needed for unlocking to work
  security.pam.services.swaylock.text = ''
    # Account management.
    account required pam_unix.so

    # Authentication management.
    auth sufficient pam_unix.so   likeauth try_first_pass
    auth required pam_deny.so

    # Password management.
    password sufficient pam_unix.so nullok sha512

    # Session management.
    session required pam_env.so conffile=/etc/pam/environment readenv=0
    session required pam_unix.so
  '';

  nix.settings = {
    substituters = [ "https://hyprland.cachix.org" ];
    trusted-public-keys =
      [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
  };
}
