{
  pkgs,
  ...
}:

{
  environment.systemPackages = [
    (pkgs.writeShellScriptBin "keyboard-layout-watcher" ''
      echo $(hyprctl devices -j | jq -r '.keyboards[] | .active_keymap' | cut -c 1-2 | tr 'a-z' 'A-Z' | sort | uniq -c | sort | head -n 1 | tr -d ' \t0-9')
    '')
  ];
}
