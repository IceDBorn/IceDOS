{
  pkgs,
  ...
}:

{
  environment.systemPackages = [
    (pkgs.writeShellScriptBin "game-launch" ''
      export PROTON_PREFER_SDL_INPUT="1"
      MANGOHUD="${pkgs.mangohud}/bin/mangohud"
      GAMEMODE="${pkgs.gamemode}/bin/gamemoderun"

      while [[ $# -gt 0 ]]; do
        case "$1" in
          --protonpath)
            export PROTONPATH="$2"
            shift 2
            ;;
          --fsr4)
            export FSR4_UPGRADE="1"
            export DXIL_SPIRV_CONFIG="wmma_rdna3_workaround"
            shift
            ;;
          --wayland)
            export PROTON_ENABLE_WAYLAND="1"
            shift
            ;;
          --hdr)
            export PROTON_ENABLE_WAYLAND="1"
            export PROTON_ENABLE_HDR="1"
            shift
            ;;
          --dll)
            export WINEDLLOVERRIDES="$2"
            shift 2
            ;;
          --no-sdl)
            export PROTON_PREFER_SDL_INPUT="0"
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
