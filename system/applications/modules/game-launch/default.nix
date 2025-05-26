{
  pkgs,
  ...
}:

{
  environment.systemPackages = [
    (pkgs.writeShellScriptBin "game-launch" ''
      PROTON_PREFER_SDL_INPUT="1"
      MANGOHUD="${pkgs.mangohud}/bin/mangohud"
      GAMEMODE="${pkgs.gamemode}/bin/gamemoderun"

      while [[ $# -gt 0 ]]; do
        case "$1" in
          --protonpath)
            PROTONPATH="$2"
            shift 2
            ;;
          --fsr4)
            FSR4_UPGRADE="1"
            DXIL_SPIRV_CONFIG="wmma_rdna3_workaround"
            shift
            ;;
          --wayland)
            PROTON_ENABLE_WAYLAND="1"
            shift
            ;;
          --hdr)
            PROTON_ENABLE_WAYLAND="1"
            PROTON_ENABLE_HDR="1"
            shift
            ;;
          --dll)
            WINEDLLOVERRIDES="$2"
            shift 2
            ;;
          --no-sdl)
            PROTON_PREFER_SDL_INPUT="0"
            shift
            ;;
          --no-mangohud)
            MANGOHUD=""
            shift
            ;;
          --no-gamemode)
            GAMEMODE=""
            shift
            ;;
          --game)
            GAME="$2"
            shift 2
            ;;
          *)
            echo "Unknown arg: $1" >&2
            exit 1
            ;;
        esac
      done

      "$MANGOHUD" "$GAMEMODE" "${pkgs.umu-launcher}/bin/umu-run" "$GAME"
    '')
  ];
}
