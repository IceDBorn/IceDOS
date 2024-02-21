{ pkgs, name, command }:
pkgs.writeShellScriptBin "${name}" ''

if command -v ${command}; then
    ${command}
fi
''
