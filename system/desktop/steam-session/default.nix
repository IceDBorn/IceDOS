{ config, lib, pkgs, ... }:

let
  steam-session = pkgs.writeShellScriptBin "steam-session" ''
    ln -sf ~/.local/share/Steam/steamapps ~/.steam-session/.local/share/Steam/steamapps
    export HOME=~/.steam-session
    export INTEL_DEBUG=norbc
    export mesa_glthread=true
    export STEAM_GAMESCOPE_VRR_SUPPORTED=1
    export SDL_VIDEO_MINIMIZE_ON_FOCUS_LOSS=0
    export STEAM_MANGOAPP_PRESETS_SUPPORTED=1
    export STEAM_USE_MANGOAPP=1
    export MANGOHUD_CONFIGFILE=$(mktemp /tmp/mangohud.XXXXXXXX)
    export STEAM_USE_DYNAMIC_VRS=1
    export RADV_FORCE_VRS_CONFIG_FILE=$(mktemp /tmp/radv_vrs.XXXXXXXX)
    export GAMESCOPE_MODE_SAVE_FILE=~/.config/gamescope/modes.cfg
    export GAMESCOPE_PATCHED_EDID_FILE=~/.config/gamescope/edid.bin
    export STEAM_BOOTSTRAP_CONFIG=~/.config/gamescope/bootstrap.cfg
    export STEAM_GAMESCOPE_HAS_TEARING_SUPPORT=1
    export STEAM_GAMESCOPE_TEARING_SUPPORTED=1
    export GAMESCOPE_NV12_COLORSPACE=k_EStreamColorspace_BT601
    export STEAM_GAMESCOPE_HDR_SUPPORTED=1
    export WINEDLLOVERRIDES=dxgi=n
    export STEAM_ENABLE_VOLUME_HANDLER=1
    export SRT_URLOPEN_PREFER_STEAM=1
    export STEAM_DISABLE_AUDIO_DEVICE_SWITCHING=1
    export STEAM_MULTIPLE_XWAYLANDS=1
    export STEAM_GAMESCOPE_DYNAMIC_FPSLIMITER=1
    export STEAM_GAMESCOPE_NIS_SUPPORTED=1
    export vk_xwayland_wait_ready=false
    export STEAM_ALLOW_DRIVE_UNMOUNT=1
    export STEAM_DISABLE_MANGOAPP_ATOM_WORKAROUND=1
    export STEAM_MANGOAPP_HORIZONTAL_SUPPORTED=1
    export STEAM_GAMESCOPE_FANCY_SCALING_SUPPORT=1
    export STEAM_GAMESCOPE_VIRTUAL_WHITE=1
    export QT_IM_MODULE=steam
    export GTK_IM_MODULE=Steam
    export GAMESCOPE_LIMITER_FILE=$(mktemp /tmp/gamescope-limiter.XXXXXXXX)
    export STEAM_DISPLAY_REFRESH_LIMITS=60,144

    mkdir -p "$(dirname "$GAMESCOPE_MODE_SAVE_FILE")"
    touch "$GAMESCOPE_MODE_SAVE_FILE"

    mkdir -p "$(dirname "$GAMESCOPE_PATCHED_EDID_FILE")"
    touch "$GAMESCOPE_PATCHED_EDID_FILE"

    mkdir -p "$(dirname "$STEAM_BOOTSTRAP_CONFIG")"
    touch "$STEAM_BOOTSTRAP_CONFIG"

    mkdir -p "$(dirname "$MANGOHUD_CONFIGFILE")"
    echo "no_display" > "$MANGOHUD_CONFIGFILE"

    mkdir -p "$(dirname "$RADV_FORCE_VRS_CONFIG_FILE")"
    echo "1x1" > "$RADV_FORCE_VRS_CONFIG_FILE"

    POSTINSTALL=~/.post-install # Delete this file if you did not get past the install phase on first boot
    if [ ! -f "$POSTINSTALL" ]; then
        touch $POSTINSTALL
        COMMAND="mangoapp & gamemoderun steam -gamepadui -steamdeck"
    else
        COMMAND="mangoapp & gamemoderun steam -gamepadui -steamos3 -steampal -steamdeck"
    fi

    gamescope --cursor ~/.icons/default/cursors/default -e -W ${config.desktop-environment.steam.session.width} -H ${config.desktop-environment.steam.session.height} --xwayland-count 2 --default-touch-mode 4 --hide-cursor-delay 3000 --fade-out-duration 200 -- bash -c "$COMMAND"
  '';
in {
  environment.systemPackages = [ steam-session ];
  services.xserver.displayManager.session =
    lib.mkIf config.desktop-environment.steam.session.enable [{
      manage = "desktop";
      name = "Steam";
      start = "steam-session";
    }];
}
