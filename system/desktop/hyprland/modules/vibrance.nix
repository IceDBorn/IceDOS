{ pkgs }:
pkgs.writeShellScriptBin "vibrance" ''
	hyprshade on ~/.config/hypr/vibrance.glsl
''
