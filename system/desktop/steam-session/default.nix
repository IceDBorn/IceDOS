{ config, lib, pkgs, ... }:

let
  steam-session = pkgs.writeShellScriptBin "steam-session" ''
    # ~/.steam-session setup
    mkdir -p ~/.local/share/Steam/steamapps
    mkdir -p ~/.steam-session/.local/share/Steam
    ln -sf ~/.local/share/Steam/steamapps ~/.steam-session/.local/share/Steam/steamapps
    export HOME=~/.steam-session

    # Steam Deck UI setup
    export GAMESCOPE_LIMITER_FILE=$(mktemp /tmp/gamescope-limiter.XXXXXXXX)
    export GAMESCOPE_MODE_SAVE_FILE=~/.config/gamescope/modes.cfg
    export GAMESCOPE_NV12_COLORSPACE=k_EStreamColorspace_BT601
    export GAMESCOPE_PATCHED_EDID_FILE=~/.config/gamescope/edid.bin
    export GTK_IM_MODULE=Steam
    export INTEL_DEBUG=norbc
    export MANGOHUD_CONFIGFILE=$(mktemp /tmp/mangohud.XXXXXXXX)
    export mesa_glthread=true
    export QT_IM_MODULE=steam
    export RADV_FORCE_VRS_CONFIG_FILE=$(mktemp /tmp/radv_vrs.XXXXXXXX)
    export SDL_VIDEO_MINIMIZE_ON_FOCUS_LOSS=0
    export SRT_URLOPEN_PREFER_STEAM=1
    export STEAM_ALLOW_DRIVE_UNMOUNT=1
    export STEAM_BOOTSTRAP_CONFIG=~/.config/gamescope/bootstrap.cfg
    export STEAM_DISABLE_AUDIO_DEVICE_SWITCHING=1
    export STEAM_DISABLE_MANGOAPP_ATOM_WORKAROUND=1
    export STEAM_DISPLAY_REFRESH_LIMITS=60,${config.desktop-environment.steam.session.refresh-rate}
    export STEAM_ENABLE_VOLUME_HANDLER=1
    export STEAM_GAMESCOPE_DYNAMIC_FPSLIMITER=1
    export STEAM_GAMESCOPE_FANCY_SCALING_SUPPORT=1
    export STEAM_GAMESCOPE_HAS_TEARING_SUPPORT=1
    export STEAM_GAMESCOPE_HDR_SUPPORTED=1
    export STEAM_GAMESCOPE_NIS_SUPPORTED=1
    export STEAM_GAMESCOPE_TEARING_SUPPORTED=1
    export STEAM_GAMESCOPE_VIRTUAL_WHITE=1
    export STEAM_GAMESCOPE_VRR_SUPPORTED=1
    export STEAM_MANGOAPP_HORIZONTAL_SUPPORTED=1
    export STEAM_MANGOAPP_PRESETS_SUPPORTED=1
    export STEAM_MULTIPLE_XWAYLANDS=1
    export STEAM_USE_DYNAMIC_VRS=1
    export STEAM_USE_MANGOAPP=1
    export vk_xwayland_wait_ready=false
    export WINEDLLOVERRIDES=dxgi=n

    function createFile() {
        echo $1
        echo $2
        mkdir -p "$(dirname "$1")"
        echo "$2" > "$1"
    }

    function launchSteam() {
        POSTINSTALL=~/.post-install # Delete this file if you did not get past the install phase on first boot
        if [ ! -f "$POSTINSTALL" ]; then
            touch $POSTINSTALL
            COMMAND="mangoapp & gamemoderun steam -gamepadui -steamdeck"
        else
            COMMAND="mangoapp & gamemoderun steam -gamepadui -steamos3 -steampal -steamdeck"
        fi

        gamescope --cursor ~/.icons/default/cursors/default -e -W ${config.desktop-environment.steam.session.width} \
            -H ${config.desktop-environment.steam.session.height} --xwayland-count 2 --hide-cursor-delay 3000 \
            --fade-out-duration 200 -- bash -c "$COMMAND"
    }

    createFile "$GAMESCOPE_MODE_SAVE_FILE" ""
    createFile "$GAMESCOPE_PATCHED_EDID_FILE" ""
    createFile "$MANGOHUD_CONFIGFILE" "no_display"
    createFile "$RADV_FORCE_VRS_CONFIG_FILE" "1x1"
    createFile "$STEAM_BOOTSTRAP_CONFIG" ""
    launchSteam
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
